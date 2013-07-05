module MyMoip
  class PaymentMethods
    include ActiveModel::Validations

    attr_accessor :payment_slip, :credit_card, :debit, :debit_card, :financing, :moip_wallet

    validates_inclusion_of :payment_slip, :credit_card, :debit, :debit_card, :financing, 
      :moip_wallet, :in => [true, false]

    def initialize(attrs=nil)
      attrs = {} if attrs.nil?
      
      self.payment_slip = true
      self.credit_card = true
      self.debit = true
      self.debit_card = true
      self.financing = true
      self.moip_wallet = true

      self.payment_slip = attrs[:payment_slip] unless attrs[:payment_slip].nil?
      self.credit_card = attrs[:credit_card] unless attrs[:credit_card].nil?
      self.debit = attrs[:debit] unless attrs[:debit].nil?
      self.debit_card = attrs[:debit_card] unless attrs[:debit_card].nil?
      self.financing = attrs[:financing] unless attrs[:financing].nil?
      self.moip_wallet = attrs[:moip_wallet] unless attrs[:moip_wallet].nil?
    end

    def to_xml(root = nil)
      if root.nil?
        xml = ""
        root ||= Builder::XmlMarkup.new(target: xml)
      end

      if not using_all?
        root.FormaPagamento('BoletoBancario') if payment_slip
        root.FormaPagamento('CartaoDeCredito') if credit_card
        root.FormaPagamento('DebitoBancario') if debit
        root.FormaPagamento('CartaoDeDebito') if debit_card
        root.FormaPagamento('FinanciamentoBancario') if financing
        root.FormaPagamento('CarteiraMoIP') if moip_wallet
      end

      xml
    end

    def using_all?
      payment_slip and credit_card and debit and debit_card and financing and moip_wallet
    end
  end
end