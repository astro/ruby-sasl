require 'digest/md5'

module SASL
  ##
  # RFC 2831:
  # http://tools.ietf.org/html/rfc2831
  class DigestMD5 < Mechanism
    attr_writer :cnonce

    def start
      ['auth', nil]
    end

    def challenge(content)
      c = decode_challenge(content)

      response = {}
      response['nonce'] = c['nonce']
      response['charset'] = 'utf-8'
      response['username'] = preferences.username
      response['realm'] = c['realm'] || preferences.realm
      @cnonce = generate_nonce unless defined? @cnonce
      response['cnonce'] = @cnonce
      response['nc'] = '00000001'
      response['qop'] = 'auth'
      response['digest-uri'] = preferences.digest_uri
      response['response'] = response_value(response['nonce'], response['cnonce'], response['qop'])
      ['response', encode_response(response)]
    end

    private

    def decode_challenge(text)
      challenge = {}
      
      state = :key
      key = ''
      value = ''

      text.scan(/./) do |ch|
        if state == :key
          if ch == '='
            state = :value
          elsif ch =~ /\S/
            key += ch
          end
          
        elsif state == :value
          if ch == ','
            challenge[key] = value
            key = ''
            value = ''
            state = :key
          elsif ch == '"' and value == ''
            state = :quote
          else
            value += ch
          end

        elsif state == :quote
          if ch == '"'
            state = :value
          else
            value += ch
          end
        end
      end
      challenge[key] = value unless key == ''
      
      p :decode_challenge => challenge
      challenge
    end

    def encode_response(response)
      p :encode_response => response
      response.collect do |k,v|
        if v.include?('"')
          v.sub!('\\', '\\\\')
          v.sub!('"', '\\"')
          "#{k}=\"#{v}\""
        else
          "#{k}=#{v}"
        end
      end.join(',')
    end

    def generate_nonce
      nonce = ''
      while nonce.length < 16
        c = rand(128).chr
        nonce += c if c =~ /^[a-zA-Z0-9]$/
      end
      nonce
    end

    ##
    # Function from RFC2831
    def h(s); Digest::MD5.digest(s); end
    ##
    # Function from RFC2831
    def hh(s); Digest::MD5.hexdigest(s); end
    
    ##
    # Calculate the value for the response field
    def response_value(nonce, cnonce, qop)
      p :response_value => {:nonce=>nonce,
        :cnonce=>cnonce,
        :qop=>qop,
        :username=>preferences.username,
        :realm=>preferences.realm,
        :password=>preferences.password,
        :authzid=>preferences.authzid}
      a1_h = h("#{preferences.username}:#{preferences.realm}:#{preferences.password}")
      a1 = "#{a1_h}:#{nonce}:#{cnonce}"
      if preferences.authzid
        a1 += ":#{preferences.authzid}"
      end
      if qop && (qop.downcase == 'auth-int' || qop.downcase == 'auth-conf')
        a2 = "AUTHENTICATE:#{preferences.digest_uri}:00000000000000000000000000000000"
      else
        a2 = "AUTHENTICATE:#{preferences.digest_uri}"
      end
      hh("#{hh(a1)}:#{nonce}:00000001:#{cnonce}:#{qop}:#{hh(a2)}")
    end
  end
end

