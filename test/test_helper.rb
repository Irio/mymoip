require 'test/unit'
require 'mocha/setup'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

require_relative 'live_test'
require_relative 'fixtures/fixture'
Dir[File.dirname(__FILE__) + "/lib/*.rb"].each { |file| require file }

MyMoip.sandbox_key   = 'YOUR_MOIP_KEY'
MyMoip.sandbox_token = 'YOUR_MOIP_TOKEN'
MyMoip.logger = Logger.new('/dev/null')
$VERBOSE = nil
