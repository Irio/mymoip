module MyMoip
  class Nasp
    STATUSES = {
      1 => "Autorizado",
      2 => "Iniciado",
      3 => "BoletoImpresso",
      4 => "Concluido",
      5 => "Cancelado",
      6 => "EmAnalise",
      7 => "Estornado",
      9 => "Reembolsado"
    }

    attr_accessor :id, :value, :status, :moip_code, :payment_mode,
                  :payment_method, :installments, :payer_email,
                  :credit_card_first_digits, :credit_card_last_digits,
                  :credit_card_flag, :moip_vault, :receiver_login

    def initialize(attrs)
      attrs.each do |attr, value|
        public_send(:"#{attr_map(attr)}=", value)
      end
    end

    def done?
      status == 4
    end

    def canceled?
      status == 5
    end

    def reversed?
      status == 7
    end

    def refunded?
      status == 9
    end

    private

    def attr_map(attr)
      {
        id_transacao: :id,
        valor: :value,
        status_pagamento: :status,
        cod_moip: :moip_code,
        forma_pagamento: :payment_mode,
        tipo_pagamento: :payment_method,
        parcelas: :installments,
        email_consumidor: :payer_email,
        recebedor_login: :receiver_login,
        cartao_bin: :credit_card_first_digits,
        cartao_final: :credit_card_last_digits,
        cartao_bandeira: :credit_card_flag,
        cofre: :moip_vault
      }.fetch(attr.to_sym)
    end
  end
end
