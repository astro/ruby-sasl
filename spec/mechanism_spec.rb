require 'sasl'
require 'spec'

describe SASL do
  it 'should know DIGEST-MD5' do
    sasl = SASL.new_mechanism('DIGEST-MD5', SASL::Preferences.new)
    sasl.class.should == SASL::DigestMD5
  end
  it 'should know PLAIN' do
    sasl = SASL.new_mechanism('PLAIN', SASL::Preferences.new)
    sasl.class.should == SASL::Plain
  end
  it 'should know ANONYMOUS' do
    sasl = SASL.new_mechanism('ANONYMOUS', SASL::Preferences.new)
    sasl.class.should == SASL::Anonymous
  end
end
