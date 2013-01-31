module MyMoip
  class Purchase
    attr_accessor :id, :price, :credit_card, :credit_card_owner, :code

    REASON = 'A Payment'

    def initialize(attrs)
      @id    = attrs.fetch(:id) { rand }
      @price = attrs.fetch(:price)
      @credit_card       = MyMoip::CreditCard.new(attrs.fetch(:credit_card))
      @credit_card_owner = MyMoip::Payer.new(attrs.fetch(:credit_card_owner))
    end

    def checkout!
      authorization = get_authorization!
      payment = MyMoip::CreditCardPayment.new(@credit_card,
                                              installments: 1)
      request = MyMoip::PaymentRequest.new(@id)
      request.api_call(payment, token: authorization.token)

      @code = request.code
      request.success?
    end

    private

    def get_authorization!
      instruction = MyMoip::Instruction.new(
        id: @id,
        payment_reason: Purchase::REASON,
        values: [@price],
        payer: @credit_card_owner
      )

      request = MyMoip::TransparentRequest.new(@id)
      request.api_call(instruction)
      request
    end
  end
end
