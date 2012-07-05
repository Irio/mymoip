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

end
