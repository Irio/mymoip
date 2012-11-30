module MyMoip
  class CreditCard
    include ActiveModel::Validations

    attr_accessor :logo, :card_number, :expiration_date, :security_code,
                :owner_name, :owner_birthday, :owner_phone, :owner_cpf

    AVAILABLE_LOGOS = [
      :american_express, :diners, :hipercard, :mastercard, :visa
    ]

    validates_presence_of :logo, :security_code
    validates_length_of :owner_phone, within: 10..11, allow_nil: true
    validates_length_of :security_code, within: 3..4
    validates_format_of :expiration_date, with: /\A(?:(?:0[1-9])|(?:1[02]))\/\d{2}\Z/ # %m/%y
    validates_inclusion_of :logo, in: AVAILABLE_LOGOS

    def initialize(attrs)
      self.logo            = attrs[:logo]
      self.card_number     = attrs[:card_number]
      self.expiration_date = attrs[:expiration_date]
      self.security_code   = attrs[:security_code]
      self.owner_name      = attrs[:owner_name]
      self.owner_birthday  = attrs[:owner_birthday]
      self.owner_phone     = attrs[:owner_phone]
      self.owner_cpf       = attrs[:owner_cpf]

      # Deprecated attributes
      self.owner_rg        = attrs[:owner_rg] if attrs.has_key?(:owner_rg)
    end

    def logo=(value)
      value = value.to_sym unless value.nil?
      @logo = value
    end

    def owner_birthday=(value)
      unless value.nil?
        value = Date.parse(value.to_s)
      end
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
  end
end
