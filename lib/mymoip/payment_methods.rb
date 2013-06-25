module MyMoip
  class PaymentMethods
    include ActiveModel::Validations

    attr_accessor :payment_slip, :credit_card, :debit, :debit_card, :financing, :moip_wallet

    def initialize
      self.payment_slip = true
      self.credit_card = true
      self.debit = true
      self.debit_card = true
      self.financing = true
      self.moip_wallet = true
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