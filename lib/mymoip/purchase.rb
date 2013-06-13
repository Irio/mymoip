module MyMoip
  class Purchase
    attr_accessor :id, :price, :credit_card, :payer, :reason
    attr_reader :code

    def initialize(attrs)
      @id          = attrs.fetch(:id) { rand }
      @price       = attrs.fetch(:price)
      @credit_card = MyMoip::CreditCard.new(attrs.fetch(:credit_card))
      @payer       = MyMoip::Payer.new(attrs.fetch(:payer))
      @reason      = attrs.fetch(:reason)
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
        id:             @id,
        payment_reason: @reason,
        values:         [@price],
        payer:          @payer
      )

      request = MyMoip::TransparentRequest.new(@id)
      request.api_call(instruction)
      request
    end
  end
end
