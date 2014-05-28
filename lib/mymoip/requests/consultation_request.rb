module MyMoip
  class ConsultationRequest < Request

    HTTP_METHOD   = :get
    PATH          = '/ws/alpha/ConsultarInstrucao'
    REQUIRES_AUTH = true

    def api_call(opts = {})
      params = {
        http_method:   HTTP_METHOD,
        requires_auth: REQUIRES_AUTH,
        path:          [PATH, id].join('/')
      }

      super(params, opts)
    end

    def xml_str
      @response.body
    end

  end
end
