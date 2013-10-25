module MyMoip
  class CreditCard
    include ActiveModel::Validations

    attr_accessor :logo, :card_number, :expiration_date, :security_code,
                  :owner_name, :owner_birthday, :owner_phone, :owner_cpf,
                  :perform_extra_validation

    AVAILABLE_LOGOS = [
      :american_express, :diners, :hipercard, :mastercard, :visa
    ]

    validates_presence_of :logo, :security_code
    validates_length_of :owner_phone, within: 10..11, allow_nil: true
    validates_length_of :security_code, within: 3..4
    validates_format_of :expiration_date, with: /\A(?:(?:0[1-9])|(?:1[0-2]))\/\d{2}\Z/ # %m/%y
    validates_inclusion_of :logo, in: AVAILABLE_LOGOS
    validate :owner_birthday_format
    validates_presence_of :card_number, :expiration_date, :owner_name,
                          :owner_phone, :owner_cpf,
                          if: ->(resource) { resource.perform_extra_validation }


    def initialize(attrs)
      attrs.each do |attr, value|
        public_send(:"#{attr}=", value)
      end
    end

    def logo=(value)
      value = value.to_sym unless value.nil?
      @logo = value
    end

    def owner_birthday=(value)
      value = Date.parse(value.to_s) unless value.nil?
      rescue ArgumentError; ensure
        @owner_birthday = value
    end

    def owner_phone=(value)
      unless value.nil?
        # Removes non-digits
        value.gsub!(/\D*/, '')
        # Removes zeros in the beginning
        value.gsub!(/\A0*/, '')
      end
      @owner_phone = value
    end

    def owner_rg=(value)
      warn "[DEPRECATION] `owner_rg` is deprecated. Please use `owner_cpf` instead."
      self.owner_cpf = value
    end

    def owner_cpf=(value)
      unless value.nil?
        # Removes dashes and dots
        value.gsub!(/\-|\./, '')
      end
      @owner_cpf = value
    end


    private

      def owner_birthday_format
        Date.parse(owner_birthday.to_s) unless owner_birthday.nil?
      rescue ArgumentError
        errors.add(:owner_birthday)
      end
  end
end
