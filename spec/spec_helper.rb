require 'rubygems'
require 'spec'
require 'pp'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'walruz'
require File.dirname(__FILE__) + '/scenario'

Walruz.setup do |config_walruz| 
  config_walruz.enable_array_extension
end

Spec::Runner.configure do |config|
end
