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
  end
end
