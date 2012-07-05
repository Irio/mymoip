module MyMoip
  class Instruction
    attr_accessor :id, :payment_reason, :values, :payer

    def initialize(attributes)
      @id             = attributes[:id]             if attributes.has_key?(:id)
      @payment_reason = attributes[:payment_reason] if attributes.has_key?(:payment_reason)
      @values         = attributes[:values]         if attributes.has_key?(:values)
      @payer          = attributes[:payer]          if attributes.has_key?(:payer)
    end
  end
end