module MyMoip
  class JsonParser

    def self.call(body, format)
      if format == :json
        JSON.parse body.match(/\?\((?<valid_json>.+)\)/)[:valid_json]
      else
        body
      end
    end

  end
end
