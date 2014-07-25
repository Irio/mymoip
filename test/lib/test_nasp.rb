require_relative '../test_helper'

class TestNasp < Test::Unit::TestCase
  def setup
    @nasp_params = {
      'id_transacao'     => 'abc.1234',
      'valor'            => '100',
      'status_pagamento' => 5,
      'cod_moip'         => 12345678,
      'forma_pagamento'  => 3,
      'tipo_pagamento'   => 'CartaoDeCredito',
      'parcelas'         => 1,
      'email_consumidor' => 'pagador@email.com.br',
      'recebedor_login'  => 'cliente@dominio.com.br',
      'cartao_bin'       => '123456',
      'cartao_final'     => '4324',
      'cartao_bandeira'   => 'AmericanExpress',
      'cofre'            => '4780c1fb-e47d-448e-ad7b-506c125366fc',
      'classificacao'    => 'Política do Banco Emissor'
    }
  end

  def test_nasp_params_mapping_and_methods_definition
    subject = MyMoip::Nasp.new(@nasp_params)

    assert_equal subject.transaction_id,      'abc.1234'
    assert_equal subject.paid_value,          '100'
    assert_equal subject.status,              5
    assert_equal subject.moip_code,           12345678
    assert_equal subject.payment_method_code, 3
    assert_equal subject.payment_method,      'CartaoDeCredito'
    assert_equal subject.installments,        1
    assert_equal subject.payer_mail,          'pagador@email.com.br'
    assert_equal subject.seller_mail,         'cliente@dominio.com.br'
    assert_equal subject.card_first_numbers,  '123456'
    assert_equal subject.card_last_numbers,   '4324'
    assert_equal subject.credit_card_logo,    'AmericanExpress'
    assert_equal subject.moip_lock_number,    '4780c1fb-e47d-448e-ad7b-506c125366fc'
    assert_equal subject.classification,      'Política do Banco Emissor'
  end
end
