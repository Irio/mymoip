require 'helper'

class TestPayer < Test::Unit::TestCase
  def test_getters_for_attributes
    payer = MyMoip::Payer.new(
      id: "some id",
      name: "some name",
      email: "some email",
      address_street: "some address_street",
      address_street_number: "some address_street_number",
      address_street_extra: "some address_street_extra",
      address_neighbourhood: "some address_neighbourhood",
      address_city: "some address_city",
      address_state: "some address_state",
      address_country: "some address_country",
      address_cep: "some address_cep",
      address_phone: "some address_phone"
    )

    assert_equal "some id", payer.id
    assert_equal "some name", payer.name
    assert_equal "some email", payer.email
    assert_equal "some address_street", payer.address_street
    assert_equal "some address_street_number", payer.address_street_number
    assert_equal "some address_street_extra", payer.address_street_extra
    assert_equal "some address_neighbourhood", payer.address_neighbourhood
    assert_equal "some address_city", payer.address_city
    assert_equal "some address_state", payer.address_state
    assert_equal "some address_country", payer.address_country
    assert_equal "some address_cep", payer.address_cep
    assert_equal "some address_phone", payer.address_phone
  end

  def test_validate_presence_of_id_attribute
    subject = Fixture.payer
    subject.id = nil
    assert subject.invalid?, 'should be invalid without an id'
    subject.id = ''
    assert subject.invalid?, 'should be invalid without an id'
  end

  def test_validate_presence_of_name_attribute
    subject = Fixture.payer
    subject.name = nil
    assert subject.invalid?, 'should be invalid without an name'
    subject.name = ''
    assert subject.invalid?, 'should be invalid without an name'
  end

  def test_validate_presence_of_email_attribute
    subject = Fixture.payer
    subject.email = nil
    assert subject.invalid?, 'should be invalid without an email'
    subject.email = ''
    assert subject.invalid?, 'should be invalid without an email'
  end

  def test_validate_presence_of_address_street_attribute
    subject = Fixture.payer
    subject.address_street = nil
    assert subject.invalid?, 'should be invalid without an address_street'
    subject.address_street = ''
    assert subject.invalid?, 'should be invalid without an address_street'
  end

  def test_validate_presence_of_address_street_number_attribute
    subject = Fixture.payer
    subject.address_street_number = nil
    assert subject.invalid?, 'should be invalid without an address_street_number'
    subject.address_street_number = ''
    assert subject.invalid?, 'should be invalid without an address_street_number'
  end

  def test_validate_presence_of_address_neighbourhood_attribute
    subject = Fixture.payer
    subject.address_neighbourhood = nil
    assert subject.invalid?, 'should be invalid without an address_neighbourhood'
    subject.address_neighbourhood = ''
    assert subject.invalid?, 'should be invalid without an address_neighbourhood'
  end

  def test_validate_presence_of_address_city_attribute
    subject = Fixture.payer
    subject.address_city = nil
    assert subject.invalid?, 'should be invalid without an address_city'
    subject.address_city = ''
    assert subject.invalid?, 'should be invalid without an address_city'
  end

  def test_validate_presence_of_address_state_attribute
    subject = Fixture.payer
    subject.address_state = nil
    assert subject.invalid?, 'should be invalid without an address_state'
    subject.address_state = ''
    assert subject.invalid?, 'should be invalid without an address_state'
  end

  def test_validate_length_of_address_state_attribute_in_2_chars
    subject = Fixture.payer
    subject.address_state = 'RS'
    assert subject.valid?, 'should accept 2 chars'
    subject.address_state = 'RSS'
    assert subject.invalid? && subject.errors[:address_state].present?,
      'should not accept strings with other than 2 chars'
  end

  def test_upcase_assigned_address_state
    subject = Fixture.payer
    subject.address_state = 'rs'
    assert_equal 'RS', subject.address_state
  end

  def test_validate_presence_of_address_country_attribute
    subject = Fixture.payer
    subject.address_country = nil
    assert subject.invalid?, 'should be invalid without an address_country'
    subject.address_country = ''
    assert subject.invalid?, 'should be invalid without an address_country'
  end

  def test_validate_length_of_address_country_attribute_in_3_chars
    subject = Fixture.payer
    subject.address_country = 'BRA'
    assert subject.valid?, 'should accept 3 chars'
    subject.address_country = 'BR'
    assert subject.invalid? && subject.errors[:address_country].present?,
      'should not accept strings with other than 3 chars'
  end

  def test_upcase_assigned_address_country
    subject = Fixture.payer
    subject.address_country = 'bra'
    assert_equal 'BRA', subject.address_country
  end

  def test_validate_presence_of_address_cep_attribute
    subject = Fixture.payer
    subject.address_cep = nil
    assert subject.invalid?, 'should be invalid without an address_cep'
    subject.address_cep = ''
    assert subject.invalid?, 'should be invalid without an address_cep'
  end

  def test_validate_presence_of_address_phone_attribute
    subject = Fixture.payer
    subject.address_phone = nil
    assert subject.invalid?, 'should be invalid without an address_phone'
    subject.address_phone = ''
    assert subject.invalid?, 'should be invalid without an address_phone'
  end
end
