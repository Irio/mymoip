require_relative "../test_helper"

class TestPayer < Test::Unit::TestCase
  def test_getters_for_attributes
    nasp = MyMoip::Nasp.new(
      id_transacao: "some id",
      valor: 2350,
      status_pagamento: 4,
      cod_moip: 3000,
      forma_pagamento: 7,
      tipo_pagamento: "CartaoDeCredito",
      parcelas: 1,
      email_consumidor: "joe@mail.com",
      recebedor_login: "someMoipLogin",
      cartao_bin: "123456",
      cartao_final: "4321",
      cartao_bandeira: "AmericanExpress",
      cofre: "4780c1fb-e47d-448e-ad7b-506c125366fc"
    )

    assert_equal "some id", nasp.id
    assert_equal 2350, nasp.value
    assert_equal 4, nasp.status
    assert_equal 3000, nasp.moip_code
    assert_equal 7, nasp.payment_mode
    assert_equal "CartaoDeCredito", nasp.payment_method
    assert_equal 1, nasp.installments
    assert_equal "joe@mail.com", nasp.payer_email
    assert_equal "someMoipLogin", nasp.receiver_login
    assert_equal "123456", nasp.credit_card_first_digits
    assert_equal "4321", nasp.credit_card_last_digits
    assert_equal "AmericanExpress", nasp.credit_card_flag
    assert_equal "4780c1fb-e47d-448e-ad7b-506c125366fc", nasp.moip_vault
  end

  def test_initialization_and_setters_with_string_keys
    nasp = MyMoip::Nasp.new(
      "id_transacao" => "some id",
      "valor" => 2350,
      "status_pagamento" => 4,
      "cod_moip" => 3000,
      "forma_pagamento" => 7,
      "tipo_pagamento" => "CartaoDeCredito",
      "parcelas" => 1,
      "email_consumidor" => "joe@mail.com",
      "recebedor_login" => "someMoipLogin",
      "cartao_bin" => "123456",
      "cartao_final" => "4321",
      "cartao_bandeira" => "AmericanExpress",
      "cofre" => "4780c1fb-e47d-448e-ad7b-506c125366fc"
    )

    assert_equal "some id", nasp.id
    assert_equal 2350, nasp.value
    assert_equal 4, nasp.status
    assert_equal 3000, nasp.moip_code
    assert_equal 7, nasp.payment_mode
    assert_equal "CartaoDeCredito", nasp.payment_method
    assert_equal 1, nasp.installments
    assert_equal "joe@mail.com", nasp.payer_email
    assert_equal "someMoipLogin", nasp.receiver_login
    assert_equal "123456", nasp.credit_card_first_digits
    assert_equal "4321", nasp.credit_card_last_digits
    assert_equal "AmericanExpress", nasp.credit_card_flag
    assert_equal "4780c1fb-e47d-448e-ad7b-506c125366fc", nasp.moip_vault
  end

  def test_if_status_is_done
    nasp = Fixture.nasp(status_pagamento: 4)
    assert_equal nasp.done?, true

    nasp = Fixture.nasp(status_pagamento: 3)
    assert_equal nasp.done?, false
  end

  def test_if_status_is_canceled
    nasp = Fixture.nasp(status_pagamento: 5)
    assert_equal nasp.canceled?, true

    nasp = Fixture.nasp(status_pagamento: 3)
    assert_equal nasp.canceled?, false
  end

  def test_if_status_is_reversed
    nasp = Fixture.nasp(status_pagamento: 7)
    assert_equal nasp.reversed?, true

    nasp = Fixture.nasp(status_pagamento: 3)
    assert_equal nasp.reversed?, false
  end

  def test_if_status_is_refunded
    nasp = Fixture.nasp(status_pagamento: 9)
    assert_equal nasp.refunded?, true

    nasp = Fixture.nasp(status_pagamento: 3)
    assert_equal nasp.refunded?, false
  end
end
