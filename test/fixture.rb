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

  def self.instruction(payer)
    MyMoip::Instruction.new(
      id: "some id",
      payment_reason: "some payment_reason",
      values: [100.0, 200.0],
      payer: payer
    )
  end

  def self.credit_card
    MyMoip::CreditCard.new(
      logo: :visa,
      card_number: "4916654211627608",
      expiration_date: "06/15",
      security_code: "000",
      owner_name: "Juquinha da Rocha",
      owner_birthday: Date.new(1984, 11, 3),
      owner_phone: "(51)3040-5060",
      owner_rg: "1010202030"
    )
  end

end
