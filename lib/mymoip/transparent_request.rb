require "request"

module MyMoip
  class TransparentRequest < Request

    HTTP_METHOD   = :post
    PATH          = "/ws/alpha/EnviarInstrucao/Unica"
    REQUIRES_AUTH = true

    def api_call(data, logger = MyMoip.logger)
      params = {
        body:          data.to_xml,
        http_method:   HTTP_METHOD,
        requires_auth: REQUIRES_AUTH,
        path:          PATH,
        logger:        logger
      }

      super params
    end

    def success?
      @response && @response["EnviarInstrucaoUnicaResponse"]["Resposta"]["Status"] == "Sucesso"
    rescue NoMethodError => e
      false
    end

    def token
      @response["EnviarInstrucaoUnicaResponse"]["Resposta"]["Token"] || nil
    rescue NoMethodError => e
      nil
    end

  end
end
