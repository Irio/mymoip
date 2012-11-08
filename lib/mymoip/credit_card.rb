module MyMoip
  class CreditCard
    include ActiveModel::Validations

    attr_accessor :logo, :card_number, :expiration_date, :security_code,
                :owner_name, :owner_birthday, :owner_phone, :owner_rg

    AVAILABLE_LOGOS = [
      :american_express, :diners, :hipercard, :mastercard, :visa
    ]

    validates_presence_of :logo, :security_code
    validates_length_of :owner_phone, within: 10..11

    def initialize(attrs)
      self.logo            = attrs[:logo]            if attrs.has_key?(:logo)
      self.card_number     = attrs[:card_number]     if attrs.has_key?(:card_number)
      self.expiration_date = attrs[:expiration_date] if attrs.has_key?(:expiration_date)
      self.security_code   = attrs[:security_code]   if attrs.has_key?(:security_code)
      self.owner_name      = attrs[:owner_name]      if attrs.has_key?(:owner_name)
      self.owner_birthday  = attrs[:owner_birthday]  if attrs.has_key?(:owner_birthday)
      self.owner_phone     = attrs[:owner_phone]     if attrs.has_key?(:owner_phone)
      self.owner_rg        = attrs[:owner_rg]        if attrs.has_key?(:owner_rg)
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
      unless value.nil?
        # Removes dashes and dots
        value.gsub!(/\-|\./, '')
      end
      @owner_rg = value
    end
  end
end
