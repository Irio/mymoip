require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'turn/autorun'
require 'mocha'

require 'fixture'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

Dir[File.dirname(__FILE__) + "/../lib/*.rb"].each { |file| require file }

MyMoip.logger = Logger.new "/dev/null"
