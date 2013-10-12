module MyMoip
  class PaymentSlipPayment < Payment

    def to_json
      json = {
        Forma: 'BoletoBancario'
      }

      json
    end
  end
end