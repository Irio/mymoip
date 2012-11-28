module MyMoip
  class Commission
    include ActiveModel::Validations
    attr_accessor :reason, :commissioned, :fixed_value, :percentage_value

    validates_presence_of :reason, :commissioned
    validates_presence_of :fixed_value, if: -> {percentage_value == nil}
    validates_presence_of :percentage_value, if: -> {fixed_value == nil}
    validates_numericality_of :fixed_value, greater_than_or_equal_to: 0, allow_nil:true
    validates_numericality_of :percentage_value, greater_than_or_equal_to:0, less_than_or_equal_to:100, allow_nil:true

    def initialize(args)
      self.reason = args[:reason]
      self.commissioned = args[:commissioned]
      self.fixed_value = args[:fixed_value]
      self.percentage_value = args[:percentage_value]
    end

    def to_xml(root = nil)
      raise ArgumentError, "Invalid params for Commission" if invalid?

      if root.nil?
        xml  = ""
        root ||= Builder::XmlMarkup.new(target: xml)
      end

      root.Comissionamento do |n1|
        n1.Razao reason
        n1.Comissionado {|n2| n2.LoginMoIP(commissioned)}
        n1.ValorFixo fixed_value  if fixed_value
        n1.ValorPercentual percentage_value if percentage_value
      end
      xml
    end

  end
end