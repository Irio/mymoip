module MyMoip
  class PaymentSlip
    include Validators
    include ActiveModel::Validations

    attr_accessor :expiration_date, :expiration_days, :expiration_days_type, :instruction_line_1, :instruction_line_2,
                  :instruction_line_3, :logo_url

    validates_length_of :instruction_line_1, :maximum => 63, :allow_nil => true
    validates_length_of :instruction_line_2, :maximum => 63, :allow_nil => true
    validates_length_of :instruction_line_3, :maximum => 63, :allow_nil => true

    validates_numericality_of :expiration_days, :less_than_or_equal_to => 99, :allow_nil => true
    validates_inclusion_of :expiration_days_type, :in => [:business_day, :calendar_day], :allow_nil => true

    validate :logo_url_format
    validate :expiration_date_format

    def initialize(attrs)
      self.expiration_date      = attrs[:expiration_date]
      self.expiration_days      = attrs[:expiration_days]
      self.expiration_days_type = attrs[:expiration_days_type]
      self.instruction_line_1   = attrs[:instruction_line_1]
      self.instruction_line_2   = attrs[:instruction_line_2]
      self.instruction_line_3   = attrs[:instruction_line_3]
      self.logo_url             = attrs[:logo_url]
    end

    def to_xml(root = nil)
      raise InvalidPaymentSlip if invalid?

      if root.nil?
        xml = ""
        root ||= Builder::XmlMarkup.new(target: xml)
      end

      root.DataVencimento(expiration_date.strftime('%Y-%m-%dT%H:%M:%S.%L%:z')) unless expiration_date.blank?

      if expiration_days
        type = nil
        if expiration_days_type
          if expiration_days_type == :business_day
            type = {'Tipo' => 'Uteis'}
          elsif expiration_days_type == :calendar_day
            type = {'Tipo' => 'Corridos'}
          end
        end

        root.DiasExpiracao(expiration_days, type)
      end

      root.Instrucao1(instruction_line_1) unless instruction_line_1.blank?
      root.Instrucao2(instruction_line_2) unless instruction_line_2.blank?
      root.Instrucao3(instruction_line_3) unless instruction_line_3.blank?

      root.URLLogo(logo_url) unless logo_url.blank?

      xml
    end

    private
    def logo_url_format
      if not logo_url.blank? and not valid_url?(logo_url)
        errors.add(:logo_url, 'Invalid URL format.')
      end
    end

    def expiration_date_format
      if not expiration_date.blank? and not expiration_date.instance_of?(DateTime)
        errors.add(:expiration_date, 'Expiration date must be a DateTime object.')
      end
    end
  end
end
