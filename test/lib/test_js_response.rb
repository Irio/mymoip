require_relative '../test_helper'

class TestJsResponse < Test::Unit::TestCase
  def setup_for_nested_methods
    @js_response_params = {
      'CodigoMoIP'      => '0000.1234.5678',
      'Mensagem'        => 'Requisição processada com sucesso',
      'StatusPagamento' => 'Sucesso',
      'Status'          => 'Autorizado',
      'TaxaMoIP'        => '20.00',
      'TotalPago'       => '100.00',
      'CodigoRetorno'   => '51',
      'url'             => 'https://www.moip.com.br/Instrucao.do?token=N2S021J',
      'Classificacao'   => { 'Codigo' => '3',
                             'Descricao' => 'Politica do banco emissor' }
                           }
  end

  def setup_for_one_level_nest_methods
    @js_response_params = {
      'Codigo' => '0',
      'StatusPagamento' => 'Sucesso',
      'CodigoMoIP' => 8_067_235,
      'TaxaMoIP' => '13.49',
      'Mensagem' => 'Requisição processada com sucesso',
      'url' => 'https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token=02J'
    }
  end

  def test_js_response_params_mapping_and_methods_definition_for_nested_methods
    setup_for_nested_methods
    subject = MyMoip::JsResponse.new(@js_response_params)

    assert_equal subject.moip_code,        '0000.1234.5678'
    assert_equal subject.message,          'Requisição processada com sucesso'
    assert_equal subject.payment_status,   'Sucesso'
    assert_equal subject.status,           'Autorizado'
    assert_equal subject.moip_tax_value,   '20.00'
    assert_equal subject.total_paid_value, '100.00'
    assert_equal subject.return_code,      '51'
    assert_equal subject.url,              'https://www.moip.com.br/Instrucao.do?token=N2S021J'

    assert_equal subject.classification.code,        '3'
    assert_equal subject.classification.description, 'Politica do banco emissor'
  end

  def test_js_response_params_mapping_and_methods_definition_for_one_level_nest
    setup_for_one_level_nest_methods
    subject = MyMoip::JsResponse.new(@js_response_params)

    assert_equal '0',                                                                subject.code
    assert_equal 'Sucesso',                                                          subject.payment_status
    assert_equal 8067235,                                                            subject.moip_code
    assert_equal '13.49',                                                            subject.moip_tax_value
    assert_equal 'Requisição processada com sucesso',                                subject.message
    assert_equal 'https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token=02J', subject.url
  end

  def test_success?
    setup_for_nested_methods
    subject = MyMoip::JsResponse.new(@js_response_params)
    assert subject.success?

    @js_response_params['StatusPagamento'] = 'Falha'
    subject = MyMoip::JsResponse.new(@js_response_params)

    assert_equal false, subject.success?
    assert_equal true,  subject.failed?
  end
end