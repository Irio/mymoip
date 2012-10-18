module MyMoip
  class PaymentRequest < Request

    HTTP_METHOD   = :get
    PATH          = "/rest/pagamento?callback=?"
    REQUIRES_AUTH = false
    FORMAT        = :json

    def api_call(data, extra_attrs)
      extra_attrs[:referer_url] ||= MyMoip.default_referer_url
      extra_attrs[:parser]      ||= MyMoip::JsonParser

      json = JSON.generate({
        pagamentoWidget: {
          referer:        extra_attrs[:referer_url],
          token:          extra_attrs[:token],
          dadosPagamento: data.to_json
        }
      })

      params = {
        query:         { pagamentoWidget: json },
        http_method:   HTTP_METHOD,
        requires_auth: REQUIRES_AUTH,
        path:          PATH,
        format:        FORMAT
      }
      params[:parser] = extra_attrs.delete :parser unless extra_attrs[:parser].nil?

      super params
    end

    def success?
      @response && @response["StatusPagamento"] == "Sucesso"
    end

  end
end
