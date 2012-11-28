module MyMoip
  class Instruction
    include ActiveModel::Validations

    attr_accessor :id, :payment_reason, :values, :payer,
                    :commissions, :fee_payer, :payment_receiver, :payment_receiver_nickname

    validates_presence_of :id, :payment_reason, :values, :payer
    validate :commissions_value_must_be_lesser_than_values
    validate :payment_receiver_presence_in_commissions

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

    def commissions_sum
      commissions.inject(0) do |sum, c|
        sum + (c.fixed_value || 0) + values_sum * ( (c.percentage_value || 0) / 100.0)
      end
    end

    def values_sum
      return values.inject(0){|sum,value| sum + value} if values
      return 0
    end

    protected

    def commissions_value_must_be_lesser_than_values
      errors.add :commissions,
                 "Instruction invalid. Commissions value sum is greater than instruction value sum" if commissions_sum > values_sum
    end

    def payment_receiver_presence_in_commissions
      errors.add :payment_receiver,
                 "Instruction invalid. Payment receiver can't be commissioned" if commissions.detect {|c| c.commissioned == payment_receiver}
    end

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
