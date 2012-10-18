module MyMoip
  class Request
    include HTTParty

    attr_reader :id, :data, :response

    def initialize(id)
      @id = id
    end

    def api_call(params, logger = nil, username = MyMoip.token, password = MyMoip.key)
      logger   ||= MyMoip.logger
      username ||= MyMoip.token
      password ||= MyMoip.key

      logger.info "MyMoip::Request of ##{@id} with #{params[:body].inspect}"

      url = MyMoip.api_url + params.delete(:path)
      params[:basic_auth] = { username: username, password: password }

      @response = HTTParty.send params.delete(:http_method), url, params

      logger.info "MyMoip::Request of ##{@id} to #{url} had response #{@response}"
    end
  end
end

requests = Dir[File.dirname(__FILE__) + "/requests/*.rb"]
requests.each { |f| require f }
