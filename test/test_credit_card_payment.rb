require 'helper'

class TestCreditCardPayment < Test::Unit::TestCase

  def test_initialization_and_getters
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card, 1)
    assert_equal credit_card, subject.credit_card
    assert_equal 1, subject.tranches
  end

  def test_cash_method_with_one_tranch
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card, 1)
    assert_equal true, subject.cash?
  end

  def test_cash_method_with_more_than_one_tranches
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card, 3)
    assert_equal false, subject.cash?
  end
end
