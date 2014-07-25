require 'active_support/core_ext/hash'

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

    def response_hash
      Hash.from_xml(@response.body)
    end

    def transactions
      @transactions ||= get_payment_nodes
    end

    def transaction(moip_code)
      transactions.select { |i| i.key(format_moip_code(moip_code)) }.first
    end

    private

    def format_moip_code(moip_code)
      moip_code.to_s.rjust(12, '0').scan(/\d{4}/).join('.')
    end

    def get_payment_nodes
      payments = response_hash['ConsultarTokenResponse']\
                              ['RespostaConsultar']\
                              ['Autorizacao']\
                              ['Pagamento']

      payments.is_a?(Hash) ? [payments] : payments
    end
  end
end
