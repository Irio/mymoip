module MyMoip
  class << self
    attr_accessor :token, :key, :environment

    def api_url
      if environment == "sandbox"
        "https://desenvolvedor.moip.com.br/sandbox"
      end
    end
  end
end

MyMoip.environment = "sandbox"