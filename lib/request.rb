module MyMoip
  class Request
    attr_reader :id, :data

    def initialize(id)
      @id = id
    end

    def api_call(data, logger = MyMoip.logger)
      @data = data

      logger.info "MyMoip::Request#api_call of ##{@id} with #{data.inspect}"
    end
  end
end
