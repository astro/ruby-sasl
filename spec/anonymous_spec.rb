require 'sasl'
require 'spec'

describe SASL::Anonymous do
  class MyPreferences < SASL::Preferences
    def username
      'bob'
    end
  end
  preferences = MyPreferences.new

  it 'should authenticate anonymously' do
    sasl = SASL::Anonymous.new('ANONYMOUS', preferences)
    sasl.start.should == ['auth', 'bob']
  end
end
