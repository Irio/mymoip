module MyMoip
  module ParamsMapper

    def initialize(params)
      self.class::PARAMS_MAPPER.values.each do |attribute|
        value = params[self.class::PARAMS_MAPPER.key(attribute)]

        if attribute.is_a?(Hash)
          attribute, value = [attribute.keys.first, value.values.first]
        end

        define_singleton_method attribute do value end
      end
    end
  end
end