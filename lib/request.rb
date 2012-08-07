module MyMoip
  class Request
    attr_reader :instruction, :id, :data

    def initialize(instruction, extra_attrs)
      raise ArgumentError, "No data provided" unless extra_attrs.has_key? :data

      @instruction = instruction
      @id          = extra_attrs[:id]   if extra_attrs.has_key? :id
      @data        = extra_attrs[:data] if extra_attrs.has_key? :data
    end
  end
end
