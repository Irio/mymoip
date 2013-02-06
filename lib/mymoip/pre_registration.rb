module MyMoip
  class PreRegistration
    include ActiveModel::Validations

    attr_accessor :id, :name, :surname, :email, :phone, :birth_date, :rg, :cpf, :zip_code,
                  :street, :house_number, :neighborhood,:city, :state, :country, 
                  :company_name, :trading_name, :cnpj, :company_phone, :company_zip_code

    validates_presence_of :id, :name, :surname, :email, :phone, :birth_date, :rg, :cpf, 
                          :zip_code, :street, :house_number, :neighborhood,:city, 
                          :state, :country, :company_name, :trading_name, :cnpj, 
                          :company_phone, :company_zip_code

    def initialize(attrs)
      self.id                    = attrs[:id].nil? ? Digest::MD5.hexdigest(nome + email) : attrs[:id]
      self.name                  = attrs[:name]
      self.surname               = attrs[:surname]
      self.email                 = attrs[:email]
      self.phone	               = attrs[:phone]
      self.birth_date            = attrs[:birth_date]
      self.rg		                 = attrs[:rg]
      self.cpf		               = attrs[:cpf]
      self.zip_code		           = attrs[:zip_code]
      self.street                = attrs[:street]
      self.house_number		       = attrs[:house_number]
      self.neighborhood		       = attrs[:neighborhood]
      self.city                  = attrs[:city]
      self.state		             = attrs[:state]
      self.country		           = attrs[:country]
      self.company_name		       = attrs[:company_name]
      self.trading_name		       = attrs[:trading_name]
      self.cnpj		               = attrs[:cnpj]
      self.company_zip_code		   = attrs[:company_zip_code]
      self.company_phone         = attrs[:company_phone]
    end

    def to_xml(root = nil)
      #raise InvalidPreRegistration if self.invalid?

      xml  = ""
      root = Builder::XmlMarkup.new(target: xml)

      root.PreCadastramento do |n1|
        n1.prospect do |n2|
          n2.idProprio(@id)
          n2.nome(@name)
          n2.sobrenome(@surname) 
          n2.email(@email) 
          n2.telefoneFixo(@phone) 
          n2.dataNascimento(@birth_date) 
          n2.rg(@rg)
          n2.cpf(@cpf)
          n2.cep(@zip_code)
          n2.rua(@street) 
          n2.numero(@house_number) 
          n2.bairro(@neighborhood) 
          n2.cidade(@city) 
          n2.estado(@state) 
          n2.razaoSocial(@company_name) 
          n2.nomeFantasia(@trading_name) 
          n2.cnpj(@cnpj) 
          n2.cepEmpresa(@company_zip_code) 
          n2.telefoneFixoEmpresa(@company_phone)
        end
      end  
    
      xml
    end

  end
end
