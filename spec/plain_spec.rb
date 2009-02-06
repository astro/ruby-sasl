require 'sasl'
require 'spec'

describe SASL::Plain do
  class MyPreferences < SASL::Preferences
    def authzid
      'bob@example.com'
    end
    def username
      'bob'
    end
    def has_password?
      true
    end
    def password
      's3cr3t'
    end
  end
  preferences = MyPreferences.new

  it 'should authenticate' do
    sasl = SASL::Plain.new('PLAIN', preferences)
    sasl.start.should == ['auth', "bob@example.com\000bob\000s3cr3t"]
  end
end
