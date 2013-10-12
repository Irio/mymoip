module MyMoip
  class CreditCardPayment < Payment
    attr_accessor :credit_card, :installments

    def initialize(credit_card, opts = {})
      self.credit_card  = credit_card
      self.installments = opts[:installments] || 1
    end

    def to_json(formatter = MyMoip::Formatter)
      raise InvalidCreditCard, 'No credit card provided.' if credit_card.nil?
      raise InvalidCreditCard                             if credit_card.invalid?

      json = {
        Forma:        "CartaoCredito",
        Parcelas:     @installments,
        CartaoCredito: {
          Numero:           credit_card.card_number,
          Expiracao:        credit_card.expiration_date,
          CodigoSeguranca:  credit_card.security_code
        }
      }

      json[:CartaoCredito][:Portador] = {
        Nome: credit_card.owner_name,
        DataNascimento: (credit_card.owner_birthday and
                         formatter.date(credit_card.owner_birthday)),
        Telefone: (credit_card.owner_phone and
                   formatter.phone(credit_card.owner_phone)),
        Identidade: (credit_card.owner_cpf and
                     formatter.cpf(credit_card.owner_cpf))
      }

      json[:Instituicao] = {
        american_express: "AmericanExpress",
        diners:           "Diners",
        hipercard:        "Hipercard",
        mastercard:       "Mastercard",
        visa:             "Visa"
      }.fetch(credit_card.logo)

      if cash?
        json[:Recebimento] = "AVista"
      end

      json
    end

    def cash?
      @installments == 1
    end
  end
end
