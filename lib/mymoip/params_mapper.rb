module MyMoip
  module ParamsMapper
    def initialize(params)
      self.class::PARAMS_MAPPER.values.each_with_index do |attribute, index|
        next unless params.include?(self.class::PARAMS_MAPPER.keys[index])
        value = params[self.class::PARAMS_MAPPER.key(attribute)]

        if attribute.is_a?(Hash)
          define_multiple_attributes(attribute, value); next
        end

        define_singleton_method attribute do value end
      end
    end

    def define_multiple_attributes(hash, value)
      method_name    = hash.keys.first
      mapped_methods = hash[method_name]

      obj = OpenStruct.new(Hash[ value.map { |k, v| [mapped_methods[k], v] } ])
      define_singleton_method method_name do obj end
    end
  end
end