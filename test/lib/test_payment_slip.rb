require_relative '../test_helper'

class TestPaymentSlip < Test::Unit::TestCase
  def test_validate_length_of_instruction_lines
    subject = Fixture.payment_slip()
    assert subject.valid?

    subject.instruction_line_1 = ('*' * 63)
    subject.instruction_line_2 = ('*' * 63)
    subject.instruction_line_3 = ('*' * 63)

    assert subject.valid?

    subject.instruction_line_1 = ('*' * 64)
    subject.instruction_line_2 = ('*' * 64)
    subject.instruction_line_3 = ('*' * 64)

    assert subject.invalid?
    assert subject.errors[:instruction_line_1].present? && 
     subject.errors[:instruction_line_2].present? && 
     subject.errors[:instruction_line_3].present?
  end

  def test_validate_expiration_days
    subject = Fixture.payment_slip(expiration_days: 99)
    assert subject.valid?

    subject.expiration_days = 100
    assert subject.invalid? && subject.errors[:expiration_days].present?
  end

  def test_validate_expiration_type
    subject = Fixture.payment_slip(expiration_days_type: :calendar_day)
    assert subject.valid?

    subject.expiration_days_type = :business_day
    assert subject.valid?

    subject.expiration_days_type = :another_type
    assert subject.invalid? && subject.errors[:expiration_days_type].present?
  end

  def test_validate_logo_url
    subject = Fixture.payment_slip(logo_url: 'http://www.uol.com.br')
    assert subject.valid?

    subject.logo_url = 'https://www.google.com/sdfsdf.png'
    assert subject.valid?

    subject.logo_url = 'file://www.google.com/sdfsdf.png'
    assert subject.invalid? && subject.errors[:logo_url].present?
  end
  
  def test_validate_expiration_date_format
    subject = Fixture.payment_slip(expiration_date: DateTime.new)
    assert subject.valid?

    subject.expiration_date = Date.new
    assert subject.invalid? && subject.errors[:expiration_date].present?
  end

  def test_xml_format
    subject = Fixture.payment_slip()
    expected_format = <<XML
<DataVencimento>2020-01-01T00:00:00.000+00:00</DataVencimento><DiasExpiracao Tipo="Uteis">7</DiasExpiracao><Instrucao1>Line 1</Instrucao1><Instrucao2>Line 2</Instrucao2><Instrucao3>Line 3</Instrucao3><URLLogo>http://www.myurl.com/logo.png</URLLogo>
XML
    assert_equal expected_format.rstrip, subject.to_xml
  end

  def test_xml_method_raises_exception_when_called_with_invalid_params
    subject = Fixture.payment_slip
    subject.stubs(:invalid?).returns(true)
    assert_raise MyMoip::InvalidPaymentSlip do
      subject.to_xml
    end
  end

end
