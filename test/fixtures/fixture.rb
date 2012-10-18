class Fixture
  def self.payer
    MyMoip::Payer.new(
      id: "your_own_payer_id",
      name: "Juquinha da Rocha",
      email: "juquinha@rocha.com",
      address_street: "Felipe Neri",
      address_street_number: "406",
      address_street_extra: "Sala 501",
      address_neighbourhood: "Auxiliadora",
      address_city: "Porto Alegre",
      address_state: "RS",
      address_country: "BRA",
      address_cep: "90440-150",
      address_phone: "(51)3040-5060"
    )
  end

  def self.instruction(payer)
    MyMoip::Instruction.new(
      id: "your_own_instruction_id",
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
