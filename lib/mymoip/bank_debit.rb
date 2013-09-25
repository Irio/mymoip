module MyMoip
  class BankDebit
    include ActiveModel::Validations

    attr_accessor :bank

    AVAILABLE_BANKS = [:banco_do_brasil, :bradesco, :banrisul, :itau]

    validates :bank, presence: true, inclusion: AVAILABLE_BANKS

    def initialize(attrs)
      attrs.each do |attr, value|
        public_send(:"#{attr}=", value)
      end
    end

    def bank=(value)
      value = value.to_sym unless value.nil?
      @bank = value
    end
  end
end