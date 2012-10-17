require 'helper'

class TestCreditCardPayment < Test::Unit::TestCase

  def test_initialization_and_getters
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card, 1)
    assert_equal credit_card, subject.credit_card
    assert_equal 1, subject.installments
  end

  def test_allow_initialization_with_a_hash_of_options
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card, installments: 2)
    assert_equal credit_card, subject.credit_card
    assert_equal 2, subject.installments
  end

  def test_cash_method_with_one_tranch
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card, 1)
    assert_equal true, subject.cash?
  end

  def test_cash_method_with_more_than_one_installments
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card, 3)
    assert_equal false, subject.cash?
  end

  def test_default_initialization_with_one_tranch
    credit_card = Fixture.credit_card
    subject = MyMoip::CreditCardPayment.new(credit_card)
    assert_equal 1, subject.installments
  end

  def test_json_format
    payment = MyMoip::CreditCardPayment.new(Fixture.credit_card)
    assert_equal "CartaoCredito", payment.to_json[:Forma]
    assert payment.to_json[:Parcelas].kind_of?(Integer), "'Parcelas' must be a kind of integer."
  end

  def test_json_credit_card_format
    payment = MyMoip::CreditCardPayment.new(Fixture.credit_card)
    assert_match /\A\d+\z/, payment.to_json[:CartaoCredito][:Numero]
    assert_match /\A((0[1-9])|(1[02]))\/\d{2}\z/, payment.to_json[:CartaoCredito][:Expiracao]
    assert_match /\A\d{3}\z/, payment.to_json[:CartaoCredito][:CodigoSeguranca]
    original_date = Date.new(1980, 11, 3)
    MyMoip::CreditCard.any_instance.stubs(:owner_birthday).returns(original_date)
    assert_equal original_date.strftime("%d/%m/%Y"), payment.to_json[:CartaoCredito][:Portador][:DataNascimento]
    assert_match /\A\(\d{2}\)\d{4,5}-\d{4}/, payment.to_json[:CartaoCredito][:Portador][:Telefone]
    assert_match /\A\d+\z/, payment.to_json[:CartaoCredito][:Portador][:Identidade]
  end

end
