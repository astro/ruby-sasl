Gem::Specification.new do |s|
  s.name = 'ruby-sasl'
  s.version = "0.0.1"

  s.authors = ['Stephan Maka']
  s.date = '2009-02-06'
  s.description = 'Simple Authentication and Security Layer (RFC 4422)'
  s.email = 'stephan@spaceboyz.net'
  s.test_files = Dir["spec/*.rb"]
  s.files = s.test_files + Dir["lib/**/*.rb"] + ["README.markdown"]
  s.has_rdoc = false
  s.homepage = 'http://github.com/astro/ruby-sasl/'
  s.require_paths = ["lib"]
  s.summary = %q{SASL client library}
end
