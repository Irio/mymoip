require 'helper'

class TestCommission < Test::Unit::TestCase
  def test_initialization_and_setters
    params = {
        reason: 'Because we can',
        receiver_login: 'comissioned_indentifier',
        fixed_value: 23.5,
        percentage_value: 12.67
    }
    subject = MyMoip::Commission.new(params)
    assert_equal params[:reason], subject.reason
    assert_equal params[:receiver_login], subject.receiver_login
    assert_equal params[:fixed_value], subject.fixed_value
    assert_equal params[:percentage_value], subject.percentage_value
  end

  def test_validate_presence_of_reason
    subject = Fixture.commission(reason: nil)
    assert subject.invalid? && subject.errors[:reason].present?,
           "should be invalid without a reason"
  end

  def test_validate_presence_of_receiver_login
    subject = Fixture.commission(receiver_login: nil)
    assert subject.invalid? && subject.errors[:receiver_login].present?,
           "should be invalid without a receiver_login"
  end

  def test_validate_presence_of_fixed_value_or_percentage_value
    subject = Fixture.commission(fixed_value: nil, percentage_value: nil)

    assert subject.invalid? && subject.errors[:fixed_value].present?,
           "should be invalid without a fixed value"

    assert subject.invalid? && subject.errors[:percentage_value].present?,
           "should be invalid without a percentage value"

    subject.fixed_value = 2
    assert subject.valid?, "should be valid with only fixed value set"

    subject.fixed_value = nil
    subject.percentage_value = 2
    assert subject.valid?, "should be valid with only percentage value set"

    subject.fixed_value = subject.percentage_value
    assert subject.valid?, "should be valid with both values set"
  end


  def test_validate_numericality_of_fixed_value
    subject = Fixture.commission fixed_value: "I'm not a number"
    assert subject.invalid? && subject.errors[:fixed_value].present?,
           "should be invalid with a non number"
  end

  def test_validate_numericality_of_percentage_value
    subject = Fixture.commission percentage_value: "I'm not a number", fixed_value: nil
    assert subject.invalid? && subject.errors[:percentage_value].present?,
           "should be invalid with a non number"
  end

  def test_validate_positive_number_of_fixed_value
    subject = Fixture.commission fixed_value: -0.1
    assert subject.invalid? && subject.errors[:fixed_value].present?,
           "should be invalid with negative number"
  end

  def test_validate_percentage_number_of_percentage_value
    subject = Fixture.commission percentage_value: -0.1, fixed_value: nil
    assert subject.invalid? && subject.errors[:percentage_value].present?,
           "should be invalid if not within (0..100)"
    subject.percentage_value = 100.01
    assert subject.invalid? && subject.errors[:percentage_value].present?,
           "should be invalid if not within (0..100)"
  end

  def test_xml_format_with_fixed_value
    subject = Fixture.commission fixed_value: 5
    expected_format = <<XML
<Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5</ValorFixo></Comissionamento>
XML
    assert_equal expected_format.rstrip, subject.to_xml
  end

  def test_xml_format_with_percentage_value
    subject = Fixture.commission percentage_value: 5, fixed_value: nil
    expected_format = <<XML
<Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>5</ValorPercentual></Comissionamento>
XML
    assert_equal expected_format.rstrip, subject.to_xml
  end

  def test_xml_method_raises_exception_when_called_with_invalid_params
    subject = Fixture.commission
    subject.stubs(:invalid?).returns(true)
    assert_raise ArgumentError do
      subject.to_xml
    end
  end

end