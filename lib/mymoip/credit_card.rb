module MyMoip
  class CreditCard
    attr_accessor :logo, :card_number, :expiration_date, :security_code,
                :owner_name, :owner_birthday, :owner_phone, :owner_cpf

    AVAILABLE_LOGOS = [
      :american_express, :diners, :hipercard, :mastercard, :visa
    ]

    def initialize(params)
      @logo            = params[:logo]            if params.has_key? :logo
      @card_number     = params[:card_number]     if params.has_key? :card_number
      @expiration_date = params[:expiration_date] if params.has_key? :expiration_date
      @security_code   = params[:security_code]   if params.has_key? :security_code
      @owner_name      = params[:owner_name]      if params.has_key? :owner_name
      @owner_birthday  = params[:owner_birthday]  if params.has_key? :owner_birthday
      @owner_phone     = params[:owner_phone]     if params.has_key? :owner_phone
      @owner_cpf       = params[:owner_cpf]       if params.has_key? :owner_cpf

      self.owner_rg    = params[:owner_rg]        if params.has_key? :owner_rg
    end

    def owner_rg=(value)
      warn "[DEPRECATION] `owner_rg` is deprecated. Please use `owner_cpf` instead."
      self.owner_cpf = value
    end
  end
end
