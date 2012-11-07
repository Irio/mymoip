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

    def initialize(params)
      @logo            = params[:logo]            if params.has_key? :logo
      @card_number     = params[:card_number]     if params.has_key? :card_number
      @expiration_date = params[:expiration_date] if params.has_key? :expiration_date
      @security_code   = params[:security_code]   if params.has_key? :security_code
      @owner_name      = params[:owner_name]      if params.has_key? :owner_name
      @owner_birthday  = params[:owner_birthday]  if params.has_key? :owner_birthday
      @owner_phone     = params[:owner_phone]     if params.has_key? :owner_phone
      @owner_rg        = params[:owner_rg]        if params.has_key? :owner_rg
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
