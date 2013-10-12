module MyMoip
  class Payment
    def self.payment_method
      name.gsub(/^MyMoip::|Payment$/, '').gsub(/([a-z])([A-Z])/,'\1_\2').downcase.to_sym
    end
  end
end

payments = Dir[File.dirname(__FILE__) + "/payments/*.rb"]
payments.each { |f| require f }
