class Fixture
  def self.payer(params = {})
    params = {
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
    }.merge(params)
    MyMoip::Payer.new(params)
  end

  def self.instruction(params={})
    params = {
      id: "your_own_instruction_id",
      payment_reason: "some payment_reason",
      values: [100.0, 200.0],
      payer: payer,
      installments: [
        {min: 2, max: 12, forward_taxes: true, fee: 1.99}
      ]
    }.merge(params)
    MyMoip::Instruction.new(params)
  end

  def self.credit_card(params = {})
    params = {
      logo: :visa,
      card_number: "4916654211627608",
      expiration_date: "06/15",
      security_code: "000",
      owner_name: "Juquinha da Rocha",
      owner_birthday: Date.new(1984, 11, 3),
      owner_phone: "(51)3040-5060",
      owner_cpf: "522.116.706-95"
    }.merge(params)
    MyMoip::CreditCard.new(params)
  end

  def self.commission(params = {})
    params = {
        reason: 'Because we can',
        receiver_login: 'commissioned_indentifier',
        fixed_value: 23.4
    }.merge(params)
    MyMoip::Commission.new(params)
  end

  def self.payment_slip(params = {})
    params = {
        expiration_date: DateTime.new(2020, 1, 1),
        expiration_days: 7,
        expiration_days_type: :business_day,
        instruction_line_1: 'Line 1',
        instruction_line_2: 'Line 2',
        instruction_line_3: 'Line 3',
        logo_url: 'http://www.myurl.com/logo.png'
    }.merge(params)
    MyMoip::PaymentSlip.new(params)
  end

  def self.bank_debit(params = {})
    params = { bank: :itau }.merge(params)
    MyMoip::BankDebit.new(params)
  end


  def self.nasp(params = {})
    params = {
      id_transacao: "some id",
      valor: 2350,
      status_pagamento: 4,
      cod_moip: 3000,
      forma_pagamento: 7,
      tipo_pagamento: "CartaoDeCredito",
      parcelas: 1,
      email_consumidor: "joe@mail.com",
      cartao_bin: "123456",
      cartao_final: "4321",
      cartao_bandeira: "AmericanExpress",
      cofre: "4780c1fb-e47d-448e-ad7b-506c125366fc"
    }.merge(params)
    MyMoip::Nasp.new(params)
  end
end
