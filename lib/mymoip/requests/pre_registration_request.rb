module MyMoip
  class PreRegistrationRequest < Request

    HTTP_METHOD   = :post
    PATH          = "/ws/alpha/PreCadastramento"
    REQUIRES_AUTH = true

    def api_call(data, opts = {})
      params = {
        body:          data.to_xml,
        http_method:   HTTP_METHOD,
        requires_auth: REQUIRES_AUTH,
        path:          PATH
      }

      super(params, opts)
    end

    def success?
      @response && @response['PreCadastramentoResponse']["RespostaPreCadastramento"]["Status"] == "Sucesso"
    rescue NoMethodError => e
      false
    end

    def id_redirecionamento
      @response['PreCadastramentoResponse']["RespostaPreCadastramento"]["idRedirecionamento"] || nil
    rescue NoMethodError => e
      nil
    end

    def id
      @response['PreCadastramentoResponse']["RespostaPreCadastramento"]["ID"]
    rescue NoMethodError => e
      nil
    end

    def response
      @response
    end

  end
end
