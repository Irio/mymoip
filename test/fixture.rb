class Fixture
  def self.payer
    MyMoip::Payer.new(
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
  end

  def self.instruction
    MyMoip::Instruction.new(
      id: "some id",
      payment_reason: "some payment_reason",
      values: "some values",
      payer: payer
    )
  end

end