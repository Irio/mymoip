require_relative '../test_helper'

class TestBankDebitPayment < Test::Unit::TestCase
  def test_initialization_and_setters
    bank_debit = Fixture.bank_debit
    subject = MyMoip::BankDebitPayment.new(bank_debit)
    assert_equal bank_debit, subject.bank_debit
  end

  def test_json_format
    payment = MyMoip::BankDebitPayment.new(Fixture.bank_debit)
    assert_equal "DebitoBancario", payment.to_json[:Forma]
  end

  def test_to_json_should_accept_any_bank_from_available_banks_constant
    MyMoip::BankDebit::AVAILABLE_BANKS.each do |bank|
      payment = MyMoip::BankDebitPayment.new(Fixture.bank_debit(bank: bank))
      assert_nothing_raised(KeyError) { payment.to_json }
    end
  end

  def test_to_json_method_raises_an_exception_when_called_without_a_bank_debit
    subject = MyMoip::BankDebitPayment.new(nil)
    assert_raise(MyMoip::InvalidBankDebit) { subject.to_json }
  end

  def test_to_json_method_raises_an_exception_when_called_with_a_invalid_bank_debit
    subject = MyMoip::BankDebitPayment.new(Fixture.bank_debit)
    MyMoip::BankDebit.any_instance.stubs(:invalid?).returns(true)
    assert_raise(MyMoip::InvalidBankDebit) { subject.to_json }
  end
end
