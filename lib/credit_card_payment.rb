module MyMoip
  class CreditCardPayment
    attr_accessor :credit_card, :tranches

    def initialize(credit_card, tranches)
      @credit_card, @tranches = credit_card, tranches
    end

    def to_xml

    end

    def cash?
      @tranches == 1
    end
  end
end
