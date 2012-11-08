module MyMoip
  class Formatter
    def self.cep(plain_cep)
      raise ArgumentError, 'Cannot format CEP nil' if plain_cep.nil?
      plain_cep.gsub(/(\d{5})/, '\1-')
    end

    def self.phone(plain_phone)
      raise ArgumentError, 'Cannot format phone nil' if plain_phone.nil?
      plain_phone.gsub(/(\d{2})(\d)?(\d{4})(\d{4})/, '(\1)\2\3-\4')
    end

    def self.date(plain_date)
      raise ArgumentError, 'Cannot format date nil' if plain_date.nil?
      plain_date.strftime("%d/%m/%Y")
    end
  end
end
