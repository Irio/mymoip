module MyMoip
  class TransparentRequest < Request

    HTTP_METHOD   = :post
    PATH          = "/ws/alpha/EnviarInstrucao/Unica"
    REQUIRES_AUTH = true

    def initialize(id)
      super
    end

    def api_call(data, logger = MyMoip.logger)
      super(http_method: HTTP_METHOD, path: PATH, requires_auth: REQUIRES_AUTH, logger: logger)
    end
  end
end
