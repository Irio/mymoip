module MyMoip
  class Payer
    include ActiveModel::Validations

    attr_accessor :id, :name, :email,
                  :address_street, :address_street_number, :address_street_extra,
                  :address_neighbourhood, :address_city, :address_state,
                  :address_country, :address_cep, :address_phone

    validates_presence_of :id, :name, :email, :address_street,
                          :address_street_number, :address_neighbourhood,
                          :address_city, :address_state, :address_country,
                          :address_cep, :address_phone
    validates_length_of :address_state, is: 2
    validates_length_of :address_country, is: 3
    validates_length_of :address_cep, is: 8
    validates_length_of :address_phone, within: 10..11

    def initialize(attrs)
      self.id                    = attrs[:id]                     if attrs.has_key?(:id)
      self.name                  = attrs[:name]                   if attrs.has_key?(:name)
      self.email                 = attrs[:email]                  if attrs.has_key?(:email)
      self.address_street        = attrs[:address_street]         if attrs.has_key?(:address_street)
      self.address_street_number = attrs[:address_street_number]  if attrs.has_key?(:address_street_number)
      self.address_street_extra  = attrs[:address_street_extra]   if attrs.has_key?(:address_street_extra)
      self.address_neighbourhood = attrs[:address_neighbourhood]  if attrs.has_key?(:address_neighbourhood)
      self.address_city          = attrs[:address_city]           if attrs.has_key?(:address_city)
      self.address_state         = attrs[:address_state]          if attrs.has_key?(:address_state)
      self.address_country       = attrs[:address_country]        if attrs.has_key?(:address_country)
      self.address_cep           = attrs[:address_cep]            if attrs.has_key?(:address_cep)
      self.address_phone         = attrs[:address_phone]          if attrs.has_key?(:address_phone)
    end

    def address_cep=(value)
      value.gsub!(/\D*/, '') unless value.nil?
      @address_cep = value
    end

    def address_state=(value)
      value = value.upcase unless value.nil?
      @address_state = value
    end

    def address_country=(value)
      value = value.upcase unless value.nil?
      @address_country = value
    end

    def address_phone=(value)
      unless value.nil?
        # Removes non-digits
        value.gsub!(/\D*/, '')
        # Removes zeros in the beginning
        value.gsub!(/\A0*/, '')
      end
      @address_phone = value
    end

    def formatted_address_cep
      raise 'Invalid address_cep' if invalid? && errors[:address_cep].present?
      @address_cep.gsub(/(\d{5})/, '\1-')
    end

    def formatted_address_phone
      raise 'Invalid address_phone' if invalid? && errors[:address_phone].present?
      @address_phone.gsub(/(\d{2})(\d)?(\d{4})(\d{4})/, '(\1)\2\3-\4')
    end

    def to_xml(root = nil)
      if root.nil?
        xml  = ""
        root ||= Builder::XmlMarkup.new(target: xml)
      end

      root.Nome(@name)
      root.Email(@email)
      root.IdPagador(@id)
      root.EnderecoCobranca do |n1|
        n1.Logradouro(@address_street)
        n1.Numero(@address_street_number)
        n1.Complemento(@address_street_extra)
        n1.Bairro(@address_neighbourhood)
        n1.Cidade(@address_city)
        n1.Estado(@address_state)
        n1.Pais(@address_country)
        n1.CEP(formatted_address_cep)
        n1.TelefoneFixo(formatted_address_phone)
      end

      xml
    end
  end
end
