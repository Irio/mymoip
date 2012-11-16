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
    MyMoip::Formatter.stubs(:date).returns('03/11/1980')
    assert_equal '03/11/1980', payment.to_json[:CartaoCredito][:Portador][:DataNascimento]
    assert_match /\A\(\d{2}\)\d{4,5}-\d{4}/, payment.to_json[:CartaoCredito][:Portador][:Telefone]
    assert_match /\A\d{3}\.\d{3}\.\d{3}\-\d{2}\z/, payment.to_json[:CartaoCredito][:Portador][:Identidade]
  end

  def test_to_json_should_accept_any_creditcard_from_available_logos_constant
    MyMoip::CreditCard::AVAILABLE_LOGOS.each do |logo|
      payment = MyMoip::CreditCardPayment.new(Fixture.credit_card(logo: logo))
      assert_nothing_raised(KeyError) { payment.to_json }
    end
  end

  def test_to_json_method_uses_the_formatted_version_of_the_credit_cards_owner_birthday
    date = Date.new(2040, 10, 30)
    subject = MyMoip::CreditCardPayment.new(Fixture.credit_card(owner_birthday: date))
    formatter = stub_everything('formatter')
    formatter.expects(:date).with(date)
    subject.to_json(formatter)
  end

  def test_to_json_method_skip_formatting_when_credit_cards_owner_birthday_is_nil
    subject = MyMoip::CreditCardPayment.new(Fixture.credit_card(owner_birthday: nil))
    formatter = stub_everything('formatter')
    formatter.stubs(:date).with(nil).returns('should not be here')
    json = subject.to_json(formatter)
    assert_nil json[:CartaoCredito][:Portador][:DataNascimento]
  end

  def test_to_json_method_uses_the_formatted_version_of_the_credit_cards_owner_phone
    subject = MyMoip::CreditCardPayment.new(Fixture.credit_card(owner_phone: '5130405060'))
    formatter = stub_everything('formatter')
    formatter.expects(:phone).with('5130405060')
    subject.to_json(formatter)
  end

  def test_to_json_method_skip_formatting_when_credit_cards_owner_phone_is_nil
    subject = MyMoip::CreditCardPayment.new(Fixture.credit_card(owner_phone: nil))
    formatter = stub_everything('formatter')
    formatter.stubs(:phone).with(nil).returns('should not be here')
    json = subject.to_json(formatter)
    assert_nil json[:CartaoCredito][:Portador][:Telefone]
  end

  def test_to_json_method_raises_an_exception_when_called_without_a_credit_card
    subject = MyMoip::CreditCardPayment.new(nil)
    assert_raise RuntimeError do
      subject.to_json
    end
  end

  def test_to_json_method_skip_formatting_when_credit_cards_owner_cpf_is_nil
    subject = MyMoip::CreditCardPayment.new(Fixture.credit_card(owner_cpf: nil))
    formatter = stub_everything('formatter')
    formatter.stubs(:cpf).with(nil).returns('should not be here')
    json = subject.to_json(formatter)
    assert_nil json[:CartaoCredito][:Portador][:Identidade]
  end

  def test_to_json_method_raises_an_exception_when_called_with_a_invalid_credit_card
    subject = MyMoip::CreditCardPayment.new(Fixture.credit_card)
    MyMoip::CreditCard.any_instance.stubs(:invalid?).returns(true)
    assert_raise ArgumentError do
      subject.to_json
    end
  end
end
