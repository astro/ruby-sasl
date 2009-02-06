##
# RFC 4422:
# http://tools.ietf.org/html/rfc4422
module SASL
  ##
  # You must derive from class Preferences and overwrite methods you
  # want to implement.
  class Preferences
    ##
    # Authorization identitiy ('username@domain' in XMPP)
    def authzid
      nil
    end

    ##
    # Realm ('domain' in XMPP)
    def realm
      raise AbstractMethod
    end


    ##
    # digest-uri: serv-type/serv-name | serv-type/host/serv-name
    # ('xmpp/domain' in XMPP)
    def digest_uri
      raise AbstractMethod
    end

    def username
      raise AbstractMethod
    end

    def has_password?
      false
    end

    def allow_plaintext?
      false
    end

    def password
      ''
    end

    def want_anonymous?
      false
    end
  end

  ##
  # Will be raised by SASL.new_mechanism if mechanism passed to the
  # constructor is not known.
  class UnknownMechanism < RuntimeError
    def initialize(mechanism)
      @mechanism = mechanism
    end

    def to_s
      "Unknown mechanism: #{@mechanism.inspect}"
    end
  end

  ##
  # Create a SASL Mechanism for the named mechanism
  #
  # mechanism:: [String] mechanism name
  def SASL.new_mechanism(mechanism, preferences)
    mechanism_class = case mechanism
                      when 'DIGEST-MD5'
                        DigestMD5
                      when 'PLAIN'
                        Plain
                      when 'ANONYMOUS'
                        Anonymous
                      else
                        raise UnknownMechanism.new(mechanism)
                      end
    mechanism_class.new(mechanism, preferences)
  end


  class AbstractMethod < Exception # :nodoc:
    def to_s
      "Abstract method is not implemented"
    end
  end

  ##
  # Common functions for mechanisms
  #
  # Mechanisms implement handling of methods start and challenge. They
  # return: [message_name, content] where message_name is either
  # 'auth' or 'response'.
  class Mechanism
    attr_reader :mechanism
    attr_reader :preferences

    def initialize(mechanism, preferences)
      @mechanism = mechanism
      @preferences = preferences
    end

    def start
      raise AbstractMethod
    end

    def challenge(content)
      raise AbstractMethod
    end
  end
end
