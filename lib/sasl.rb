SASL_PATH = File.dirname(__FILE__) + "/sasl"
Dir.foreach(SASL_PATH) do |f|
  require "#{SASL_PATH}/#{f}" if f =~ /\.rb$/
end
