Gem::Specification.new do |s|
  s.name = 'ruby-sasl'
  s.version = "0.0.2"

  s.authors = ['Stephan Maka']
  s.date = '2009-02-06'
  s.description = 'Simple Authentication and Security Layer (RFC 4422)'
  s.email = 'stephan@spaceboyz.net'
  s.test_files = %w(spec/mechanism_spec.rb
                    spec/anonymous_spec.rb
                    spec/plain_spec.rb
                    spec/digest_md5_spec.rb)
  s.files = s.test_files + %w(lib/sasl/base.rb
                              lib/sasl/digest_md5.rb
                              lib/sasl/anonymous.rb
                              lib/sasl/plain.rb
                              lib/sasl/base64.rb
                              lib/sasl.rb
                              README.markdown)
  s.has_rdoc = false
  s.homepage = 'http://github.com/astro/ruby-sasl/'
  s.require_paths = ["lib"]
  s.summary = 'SASL client library'
end
