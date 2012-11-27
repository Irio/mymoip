module MyMoip
  class Instruction
    include ActiveModel::Validations

    attr_accessor :id, :payment_reason, :values, :payer,
                    :commissions, :fee_payer, :payment_receiver, :payment_receiver_nickname

    validates_presence_of :id, :payment_reason, :values, :payer

    def initialize(attrs)
      self.id             = attrs[:id]             if attrs.has_key?(:id)
      self.payment_reason = attrs[:payment_reason] if attrs.has_key?(:payment_reason)
      self.values         = attrs[:values]         if attrs.has_key?(:values)
      self.payer          = attrs[:payer]          if attrs.has_key?(:payer)
      self.commissions = attrs[:commissions] || []
      self.fee_payer = attrs[:fee_payer] if attrs.has_key?(:fee_payer)
      self.payment_receiver = attrs[:payment_receiver] if attrs.has_key?(:payment_receiver)
      self.payment_receiver_nickname = attrs[:payment_receiver_nickname] if attrs.has_key?(:payment_receiver_nickname)
    end

    def to_xml(root = nil)
      raise ArgumentError, 'Invalid payer' if payer.invalid?
      raise ArgumentError, 'Invalid params for instruction' if self.invalid?
      raise ArgumentError, 'Instruction has an invalid commission' if self.commissions.detect {|c| c.invalid? }

      xml  = ""
      root = Builder::XmlMarkup.new(target: xml)

      root.EnviarInstrucao do |n1|
        n1.InstrucaoUnica(TipoValidacao: "Transparente") do |n2|
          n2.Razao(@payment_reason)
          n2.Valores do |n3|
            @values.each { |v| n3.Valor("%.2f" % v, moeda: "BRL") }
          end
          n2.IdProprio(@id)

          commissions_to_xml n2  if !commissions.empty?
          payment_receiver_to_xml n2 if payment_receiver

          n2.Pagador { |n3| @payer.to_xml(n3) }
        end
      end

      xml
    end

    protected

    def commissions_to_xml(node)
      node.Comissoes do |n|
        commissions.each {|c| c.to_xml(n)}
        n.PagadorTaxa {|pt| pt.LoginMoIP(fee_payer)} if fee_payer
      end
    end

    def payment_receiver_to_xml(node)
      node.Recebedor do |n|
        n.LoginMoIP(self.payment_receiver)
        n.Apelido(self.payment_receiver_nickname)
      end
    end

  end
end
