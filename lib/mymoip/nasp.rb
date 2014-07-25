module MyMoip
  class Nasp
    PARAMS_MAPPER = {
      'id_transacao'     => 'transaction_id',
      'valor'            => 'paid_value',
      'status_pagamento' => 'status',
      'cod_moip'         => 'moip_code',
      'forma_pagamento'  => 'payment_method_code', # 1
      'tipo_pagamento'   => 'payment_method',      # BoletoBancario
      'parcelas'         => 'installments',
      'email_consumidor' => 'payer_mail',
      'recebedor_login'  => 'seller_mail',
      'cartao_bin'       => 'card_first_numbers',
      'cartao_final'     => 'card_last_numbers',
      'cartao_bandeira'  => 'credit_card_logo',
      'cofre'            => 'moip_lock_number',
      'classificacao'    => 'classification'
    }

    include MyMoip::ParamsMapper
  end
end