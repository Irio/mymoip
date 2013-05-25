require_relative '../test_helper'

class TestFormatter < Test::Unit::TestCase
  def test_cep_method_returns_the_given_cep_with_section_separator
    assert_equal '92400-123', MyMoip::Formatter.cep('92400123')
  end

  def test_cep_method_raises_exception_with_nil_cep_given
    assert_raise ArgumentError do
      MyMoip::Formatter.cep(nil)
    end
  end

  def test_phone_method_returns_the_given_8_digit_phone_with_section_separators
    assert_equal '(51)3040-5060', MyMoip::Formatter.phone('5130405060')
  end

  def test_phone_method_returns_the_given_9_digit_phone_with_section_separators
    assert_equal '(51)93040-5060', MyMoip::Formatter.phone('51930405060')
  end

  def test_phone_method_raises_exception_with_nil_phone_given
    assert_raise ArgumentError do
      MyMoip::Formatter.phone(nil)
    end
  end

  def test_date_method_returns_the_given_date_in_the_format_expected
    date = Date.new(2040, 10, 30)
    assert_equal '30/10/2040', MyMoip::Formatter.date(date)
  end

  def test_date_method_raises_exception_with_nil_date_given
    assert_raise ArgumentError do
      MyMoip::Formatter.date(nil)
    end
  end

  def test_cpf_method_returns_the_given_number_with_section_separators
    cpf = '522.116.706-95'
    assert_equal '522.116.706-95', MyMoip::Formatter.cpf('52211670695')
  end

  def test_cpf_method_raises_exception_with_nil_cpf_given
    assert_raise ArgumentError do
      MyMoip::Formatter.cpf(nil)
    end
  end
end
