module MyMoip
  class Instruction
    include ActiveModel::Validations

    attr_accessor :id, :payment_reason, :values, :payer

    validates_presence_of :id, :payment_reason, :values, :payer

    def initialize(attrs)
      @id             = attrs[:id]             if attrs.has_key?(:id)
      @payment_reason = attrs[:payment_reason] if attrs.has_key?(:payment_reason)
      @values         = attrs[:values]         if attrs.has_key?(:values)
      @payer          = attrs[:payer]          if attrs.has_key?(:payer)
    end

    def to_xml(root = nil)
      raise ArgumentError, 'Invalid payer' if payer.invalid?
      raise ArgumentError, 'Invalid params for instruction' if self.invalid?

      xml  = ""
      root = Builder::XmlMarkup.new(target: xml)

      root.EnviarInstrucao do |n1|
        n1.InstrucaoUnica(TipoValidacao: "Transparente") do |n2|
          n2.Razao(@payment_reason)
          n2.Valores do |n3|
            @values.each { |v| n3.Valor("%.2f" % v, moeda: "BRL") }
          end
          n2.IdProprio(@id)
          n2.Pagador { |n3| @payer.to_xml(n3) }
        end
      end

      xml
    end
  end
end
