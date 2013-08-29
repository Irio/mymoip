module MyMoip
  module Validators
    private

    def valid_url?(url)
      uri = URI.parse(url)
      uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end
  end
end
