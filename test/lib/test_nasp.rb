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
      'classificacao'    => 'Solicitado pelo vendedor'
    }
  end

  def test_nasp_params_mapping_and_methods_definition
    subject = MyMoip::Nasp.new(@nasp_params)

    assert_equal @nasp_params['id_transacao'],     subject.transaction_id
    assert_equal @nasp_params['valor'],            subject.paid_value
    assert_equal @nasp_params['status_pagamento'], subject.status
    assert_equal @nasp_params['cod_moip'],         subject.moip_code
    assert_equal @nasp_params['forma_pagamento'],  subject.payment_method
    assert_equal @nasp_params['tipo_pagamento'],   subject.payment_type
    assert_equal @nasp_params['parcelas'],         subject.installments
    assert_equal @nasp_params['email_consumidor'], subject.payer_mail
    assert_equal @nasp_params['recebedor_login'],  subject.seller_mail
    assert_equal @nasp_params['cartao_bin'],       subject.card_first_numbers
    assert_equal @nasp_params['cartao_final'],     subject.card_last_numbers
    assert_equal @nasp_params['cofre'],            subject.moip_lock_number
    assert_equal @nasp_params['classificacao'],    subject.classification
  end
end
