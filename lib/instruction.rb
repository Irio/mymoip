module MyMoip
  class Instruction
    attr_accessor :id, :payment_reason, :values, :payer

    def initialize(attributes)
      @id             = attributes[:id]             if attributes.has_key?(:id)
      @payment_reason = attributes[:payment_reason] if attributes.has_key?(:payment_reason)
      @values         = attributes[:values]         if attributes.has_key?(:values)
      @payer          = attributes[:payer]          if attributes.has_key?(:payer)
    end

    def to_xml(root = nil)

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