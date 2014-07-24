module MyMoip
  class Nasp
    NASP_PARAMS_MAPPER = {
      'id_transacao'     => 'transaction_id',
      'valor'            => 'paid_value',
      'status_pagamento' => 'status',
      'cod_moip'         => 'moip_code',
      'forma_pagamento'  => 'payment_method',
      'tipo_pagamento'   => 'payment_type',
      'parcelas'         => 'installments',
      'email_consumidor' => 'consumer_mail',
      'classificacao'    => 'classification'
    }

    NASP_PARAMS_MAPPER.values.map(&:to_sym).each do |attribute|
      attr_accessor attribute
    end

    def initialize(response_params)
      @response_params = response_params
      map_and_define_methods!
    end

    private

    def map_and_define_methods!
      @response_params.each do |key, value|
        if NASP_PARAMS_MAPPER.keys.include?(key)
          define_singleton_method NASP_PARAMS_MAPPER.fetch(key) do
            value
          end
        end
      end
    end
  end
end