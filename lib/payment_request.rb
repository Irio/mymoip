require 'request'

module MyMoip
  class PaymentRequest < Request

    HTTP_METHOD   = :get
    PATH          = "/rest/pagamento?callback=?"
    REQUIRES_AUTH = false

    def api_call(data, extra_attrs)
      extra_attrs[:referer_url] ||= MyMoip.default_referer_url

      json = JSON.generate({
        pagamentoWidget: {
          referer:        extra_attrs[:referer_url],
          token:          extra_attrs[:token],
          dadosPagamento: data
        }
      })

      params = {
        query:         { pagamentoWidget: json },
        http_method:   HTTP_METHOD,
        requires_auth: REQUIRES_AUTH,
        path:          PATH
      }

      super params
    end
  end
end
