module MyMoip
  class BoletoPayment
    attr_accessor :credit_card, :installments, :expiration_days, :expiration_date, 
                  :instruction_1, :instruction_2, :instruction_3

    def initialize(attrs)
      self.expiration_days      = attrs[:expiration_days]
      self.expiration_date      = attrs[:expiration_date]
      self.instruction_1        = attrs[:instruction_1]
      self.instruction_2        = attrs[:instruction_2]
      self.instruction_3        = attrs[:instruction_3]
    end

    def to_json(formatter = MyMoip::Formatter)
      json = {
        Forma:        "BoletoBancario",
        Boleto: {
          DiasExpiracao:           self.expiration_days,
          DataVencimento:          self.expiration_date,
          Instrucao1:              self.instruction_1,
          Instrucao2:              self.instruction_2,
          Instrucao3:              self.instruction_3,
        }
      }
      json
    end

  end
end
