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
      @transactions ||= get_transaction_params.map do |transaction_params|
        MyMoip::Transaction.new(transaction_params)
      end
    end

    def transaction(moip_code)
      transaction_params = get_transaction_params.select {
        |i| i.key(format_moip_code(moip_code))
      }.first
      MyMoip::Transaction.new(transaction_params)
    end

    private

    def format_moip_code(moip_code)
      moip_code.to_s.rjust(12, '0').scan(/\d{4}/).join('.')
    end

    def get_transaction_params
      payments = response_hash['ConsultarTokenResponse']\
                              ['RespostaConsultar']\
                              ['Autorizacao']\
                              ['Pagamento']

      payments.is_a?(Hash) ? [payments] : payments
    end
  end
end
