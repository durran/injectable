$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "injectable"
require "rspec"

Dir["./spec/support/**/*.rb"].each { |f| require f }
