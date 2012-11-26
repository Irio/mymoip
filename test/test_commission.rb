require 'helper'

class TestCommission < Test::Unit::TestCase
  def test_initialization_and_setters
    params = {
        reason: 'Because we can',
        commissioned: 'comissioned_indentifier',
        fixed_value: 23.5,
        percentage_value: 12.67
    }
    subject = MyMoip::Commission.new params
    assert_equal params[:reason], subject.reason
    assert_equal params[:commissioned], subject.commissioned
    assert_equal params[:fixed_value], subject.fixed_value
    assert_equal params[:percentage_value], subject.percentage_value
  end

  def test_validate_presence_of_reason
    subject = Fixture.commission(reason: nil)
    assert subject.invalid? && subject.errors[:reason].present?,
           "should be invalid without a reason"
  end

  def test_validate_presence_of_commissioned
    subject = Fixture.commission(commissioned: nil)
    assert subject.invalid? && subject.errors[:commissioned].present?,
           "should be invalid without a commissioned"
  end

  def test_validate_presence_of_fixed_value_xor_percentage_value
    subject = Fixture.commission(fixed_value: nil, percentage_value: nil)

    assert subject.invalid? && subject.errors[:fixed_value].present?,
           "should be invalid without a fixed value"

    assert subject.invalid? && subject.errors[:percentage_value].present?,
           "should be invalid without a percentage value"

    subject.fixed_value = 2
    subject.percentage_value = 2

    assert subject.invalid? && subject.errors[:percentage_value].present? && subject.errors[:fixed_value].present?,
           "should be invalid with fixed and percentage value set"
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

end