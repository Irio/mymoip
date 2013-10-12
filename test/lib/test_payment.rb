require_relative '../test_helper'

class TestPayment < Test::Unit::TestCase
  def test_payment_method_when_payment_split
    assert_equal :payment_slip, MyMoip::PaymentSlipPayment.payment_method
  end

  def test_payment_method_when_bank_debit
    assert_equal :bank_debit, MyMoip::BankDebitPayment.payment_method
  end

  def test_payment_method_when_credit_card
    assert_equal :credit_card, MyMoip::CreditCardPayment.payment_method
  end
end
