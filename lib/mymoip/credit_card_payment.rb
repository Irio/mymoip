module MyMoip
  class CreditCardPayment
    attr_accessor :credit_card, :installments

    def initialize(credit_card, opts = {})
      @credit_card = credit_card
      # Backward compatibility. See 0.2.3 CHANGELOG
      @installments = if opts.kind_of?(Integer)
                       opts
                     else
                       opts[:installments] || 1
                     end
    end

    def to_json
      raise "No CreditCard provided" if credit_card.nil?

      json = {
        Forma:        "CartaoCredito",
        Parcelas:     @installments,
        CartaoCredito: {
          Numero:           credit_card.card_number,
          Expiracao:        credit_card.expiration_date,
          CodigoSeguranca:  credit_card.security_code,
          Portador: {
            Nome:           credit_card.owner_name,
            DataNascimento: credit_card.owner_birthday.strftime("%d/%m/%Y"),
            Telefone:       credit_card.owner_phone,
            Identidade:     credit_card.owner_cpf
          }
        }
      }

      json[:Instituicao] = {
        american_express: "AmericanExpress",
        diners:           "Diners",
        hipercard:        "Hipercard",
        mastercard:       "Mastercard",
        visa:             "Visa"
      }.fetch(credit_card.logo.to_sym)

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
