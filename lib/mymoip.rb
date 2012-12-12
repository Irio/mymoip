require 'active_model'
require 'builder'
require 'logger'
require 'httparty'
require 'json'

module MyMoip
  class << self
    attr_accessor :token, :key, :environment, :logger, :default_referer_url

    def api_url
      if environment == "sandbox"
        "https://desenvolvedor.moip.com.br/sandbox"
      else
        "https://www.moip.com.br"
      end
    end
  end
end

$LOAD_PATH << "./lib/mymoip"

files = Dir[File.dirname(__FILE__) + "/mymoip/*.rb"]
files.each { |f| require f }

MyMoip.environment = "sandbox"
MyMoip.logger = Logger.new(STDOUT)
