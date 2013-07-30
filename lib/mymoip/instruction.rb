require File.expand_path(File.dirname(__FILE__) + '/validators.rb')
module MyMoip
  class Instruction
    include Validators
    include ActiveModel::Validations

    attr_accessor :id, :payment_reason, :values, :payer,
                  :commissions, :fee_payer_login, :payment_receiver_login,
                  :payment_receiver_name, :installments,
                  :notification_url, :return_url,
                  :payment_slip, :payment_methods

    validates_presence_of :id, :payment_reason, :values, :payer
    validate :commissions_value_must_be_lesser_than_values
    validate :payment_receiver_presence_in_commissions
    validate :url_format_validation

    def initialize(attrs)
      attrs.each do |attr, value|
        public_send(:"#{attr}=", value)
      end

      self.commissions ||= []
    end

    def to_xml(root = nil)
      raise InvalidPayer       if payer.invalid?
      raise InvalidPaymentSlip if payment_slip and payment_slip.invalid?
      raise InvalidInstruction if self.invalid?
      if invalid_commission = commissions.detect { |c| c.invalid? }
        raise InvalidComission, invalid_commission
      end

      xml = ""
      root = Builder::XmlMarkup.new(target: xml)

      root.EnviarInstrucao do |n1|
        n1.InstrucaoUnica(TipoValidacao: "Transparente") do |n2|
          n2.Razao(@payment_reason)
          n2.Valores do |n3|
            @values.each { |v| n3.Valor("%.2f" % v, moeda: "BRL") }
          end
          n2.IdProprio(@id)

          if @installments
            n2.Parcelamentos do |n4|
              @installments.each do |installments|
                n4.Parcelamento do |n5|
                  n5.MinimoParcelas(installments[:min])
                  n5.MaximoParcelas(installments[:max])
                  if installments[:forward_taxes]
                    n5.Repassar(installments[:forward_taxes])
                  end
                  n5.Juros(installments[:fee])
                end
              end
            end
          end

          commissions_to_xml(n2)      if commissions.any?
          payment_receiver_to_xml(n2) if payment_receiver_login

          n2.Pagador { |n3| @payer.to_xml(n3) }

          unless @payment_methods.blank? or @payment_methods.using_all?
            n2.FormasPagamento { |n3| @payment_methods.to_xml(n3) }
          end
          unless @payment_slip.blank?
            n2.Boleto { |n3| @payment_slip.to_xml(n3) }
          end
          unless @notification_url.blank?
            n2.URLNotificacao(@notification_url)
          end
          unless @return_url.blank?
            n2.URLRetorno(@return_url)
          end
        end
      end

      xml
    end

    def commissions_sum
      commissions.inject(0) do |sum, commission|
        sum + commission.gross_amount(self)
      end
    end

    def gross_amount
      values ? values.reduce(0) { |sum, value| sum + value } : 0
    end

    protected

    def commissions_value_must_be_lesser_than_values
      if commissions_sum > gross_amount
        errors.add(:commissions, "Commissions value sum is greater than instruction value sum")
      end
    end

    def payment_receiver_presence_in_commissions
      if commissions.find { |c| c.receiver_login == payment_receiver_login }
        errors.add(:payment_receiver_login, "Payment receiver can't be commissioned")
      end
    end

    def commissions_to_xml(node)
      node.Comissoes do |n|
        commissions.each { |c| c.to_xml(n) }
        n.PagadorTaxa { |pt| pt.LoginMoIP(fee_payer_login) } if fee_payer_login
      end
    end

    def payment_receiver_to_xml(node)
      node.Recebedor do |n|
        n.LoginMoIP(payment_receiver_login)
        n.Apelido(payment_receiver_name)
      end
    end

    def url_format_validation
      if not notification_url.blank? and not valid_url?(notification_url)
        errors.add(:notification_url, 'Invalid URL format')
      end

      if not return_url.blank? and not valid_url?(return_url)
        errors.add(:return_url, 'Invalid URL format.')
      end
    end
  end
end
