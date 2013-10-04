require_relative '../test_helper'

class TestBankDebit < Test::Unit::TestCase
  def test_initialization_and_setters
    subject = MyMoip::BankDebit.new(bank: :itau)
    assert_equal :itau, subject.bank
  end

  def test_initialization_and_setters_with_string_keys
    subject = MyMoip::BankDebit.new('bank' => :itau)
    assert_equal :itau, subject.bank
  end

  def test_validate_presence_of_bank_attribute
    subject = Fixture.bank_debit(bank: nil)
    assert subject.invalid? && subject.errors[:bank].present?,
      'should be invalid without a bank name'
  end

  def test_converts_bank_string_to_symbol
    subject = Fixture.bank_debit(bank: "itau")
    assert_equal :itau, subject.bank
  end

  def test_accepts_any_bank_from_available_banks_constant
    MyMoip::BankDebit::AVAILABLE_BANKS.each do |bank|
      subject = Fixture.bank_debit(bank: bank)
      assert subject.valid?, 'should be valid'
    end
  end

  def test_dont_accept_bank_out_of_available_banks_constant
    subject = Fixture.bank_debit(bank: :unavailable_bank)
    assert subject.invalid? && subject.errors[:bank].present?, 'should not be valid'
  end
end
