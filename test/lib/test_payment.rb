require_relative '../test_helper'

class TestPayment < Test::Unit::TestCase
  def test_payment_method_when_payment_split
    assert_equal MyMoip::PaymentSlipPayment.payment_method, :payment_slip
  end

  def test_payment_method_when_bank_debit
    assert_equal MyMoip::BankDebitPayment.payment_method, :bank_debit
  end

  def test_payment_method_when_credit_card
    assert_equal MyMoip::CreditCardPayment.payment_method, :credit_card
  end
end
