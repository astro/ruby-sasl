require 'sasl'
require 'spec'

describe SASL::DigestMD5 do
  # Preferences from http://tools.ietf.org/html/rfc2831#section-4
  class MyPreferences < SASL::Preferences
    attr_writer :serv_type
    def realm
      'elwood.innosoft.com'
    end
    def digest_uri
      "#{@serv_type}/elwood.innosoft.com"
    end
    def username
      'chris'
    end
    def has_password?
      true
    end
    def password
      'secret'
    end
  end
  preferences = MyPreferences.new

  it 'should authenticate (1)' do
    preferences.serv_type = 'imap'
    sasl = SASL::DigestMD5.new('DIGEST-MD5', preferences)
    sasl.start.should == ['auth', nil]
    sasl.cnonce = 'OA6MHXh6VqTrRk'
    response = sasl.challenge('realm="elwood.innosoft.com",nonce="OA6MG9tEQGm2hh",qop="auth",
                               algorithm=md5-sess,charset=utf-8')
    response[0].should == 'response'
    response[1].should =~ /charset="?utf-8"?/
    response[1].should =~ /username="?chris"?/
    response[1].should =~ /realm="?elwood.innosoft.com"?/
    response[1].should =~ /nonce="?OA6MG9tEQGm2hh"?/
    response[1].should =~ /nc="?00000001"?/
    response[1].should =~ /cnonce="?OA6MHXh6VqTrRk"?/
    response[1].should =~ /digest-uri="?imap\/elwood.innosoft.com"?/
    response[1].should =~ /response=d388dad90d4bbd760a152321f2143af7"?/
    response[1].should =~ /"?qop=auth"?/
  end

  it 'should authenticate (2)' do
    preferences.serv_type = 'acap'
    sasl = SASL::DigestMD5.new('DIGEST-MD5', preferences)
    sasl.start.should == ['auth', nil]
    sasl.cnonce = 'OA9BSuZWMSpW8m'
    response = sasl.challenge('realm="elwood.innosoft.com",nonce="OA9BSXrbuRhWay",qop="auth",
                               algorithm=md5-sess,charset=utf-8')
    response[0].should == 'response'
    response[1].should =~ /charset="?utf-8"?/
    response[1].should =~ /username="?chris"?/
    response[1].should =~ /realm="?elwood.innosoft.com"?/
    response[1].should =~ /nonce="?OA9BSXrbuRhWay"?/
    response[1].should =~ /nc="?00000001"?/
    response[1].should =~ /cnonce="?OA9BSuZWMSpW8m"?/
    response[1].should =~ /digest-uri="?acap\/elwood.innosoft.com"?/
    response[1].should =~ /response=6084c6db3fede7352c551284490fd0fc"?/
    response[1].should =~ /"?qop=auth"?/
  end
end
