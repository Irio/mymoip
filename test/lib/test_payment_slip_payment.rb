require_relative '../test_helper'

class TestPaymentSlipPayment < Test::Unit::TestCase
  def test_json_format
    payment = MyMoip::PaymentSlipPayment.new()
    assert_equal 'BoletoBancario', payment.to_json[:Forma]
  end
end