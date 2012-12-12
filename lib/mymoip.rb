require 'active_model'
require 'builder'
require 'logger'
require 'httparty'
require 'json'
autoload :YAML, 'yaml'

module MyMoip
  class << self
    attr_accessor :key, :token, :environment, :logger, :default_referer_url

    def api_url
      if environment == "sandbox"
        "https://desenvolvedor.moip.com.br/sandbox"
      else
        "https://www.moip.com.br"
      end
    end

    def load_config(yaml)
      config = YAML.load(yaml)
      if config.has_key?('production')
        self.environment = 'production'
      elsif config.has_key?('sandbox')
        self.environment = 'sandbox'
      end
      self.key   = config[environment].fetch('key')
      self.token = config[environment].fetch('token')
    end
  end
end

$LOAD_PATH << "./lib/mymoip"

files = Dir[File.dirname(__FILE__) + "/mymoip/*.rb"]
files.each { |f| require f }

MyMoip.environment = "sandbox"
MyMoip.logger = Logger.new(STDOUT)
