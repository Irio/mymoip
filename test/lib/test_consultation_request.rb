require_relative '../test_helper'

class TestConsultationRequest < Test::Unit::TestCase
  def test_http_method_as_post
    assert_equal :get, MyMoip::ConsultationRequest::HTTP_METHOD
  end

  def test_path
    assert_equal '/ws/alpha/ConsultarInstrucao', MyMoip::ConsultationRequest::PATH
  end

  def test_auth_requirement
    assert_equal true, MyMoip::ConsultationRequest::REQUIRES_AUTH
  end

  def test_should_provide_the_response_as_a_hash
    request = MyMoip::ConsultationRequest.new('U260F1E2P0G4N0Z2T1S0M4T3C5E4J5M8L5U0G0I0U0M0H0Y0E3X7S9X6I783')

    VCR.use_cassette('consultation_with_mult_transactions_request') {
      request.api_call
    }

    response_hash = request.response_hash
    assert_equal Hash, response_hash.class
    assert response_hash.keys.include?('ConsultarTokenResponse')
  end

  def test_transactions_object_list
    request = MyMoip::ConsultationRequest.new('TOKEN')

    request.stubs(:get_transaction_params).returns(
      [ {'Data'                 => '2012-04-02T10:45:44.000-03:00',
         'DataCredito'          => '2012-04-16T00:00:00.000-03:00',
         'TotalPago'            => '1.00',
         'TaxaParaPagador'      => '0.00',
         'TaxaMoIP'             => '0.46',
         'ValorLiquido'         => '0.56',
         'FormaPagamento'       => 'CartaoDeCredito',
         'InstituicaoPagamento' => 'AmericanExpress',
         'Parcela'              => {'TotalParcelas'=>'1'},
         'Status'               => 'Autorizado',
         'CodigoMoIP'           => '0000.2524.0547' },
        {'Data'                 => '2012-04-02T10:45:44.000-03:00',
         'DataCredito'          => '2012-04-16T00:00:00.000-03:00',
         'TotalPago'            => '10.00',
         'TaxaParaPagador'      => '1.00',
         'TaxaMoIP'             => '0.46',
         'ValorLiquido'         => '0.56',
         'FormaPagamento'       => 'CartaoDeCredito',
         'InstituicaoPagamento' => 'AmericanExpress',
         'Parcela'              => {'TotalParcelas'=>'1'},
         'Status'               => 'Autorizado',
         'CodigoMoIP'           => '0000.1234.5678'} ]
    )

    assert_equal(MyMoip::Transaction, request.transactions.first.class)
    assert_equal(MyMoip::Transaction, request.transactions.last.class)
    assert_equal(2, request.transactions.size)
  end

  def test_find_transaction_by_moip_id
    request = MyMoip::ConsultationRequest.new('TOKEN')

    request.stubs(:get_transaction_params).returns(
      [ {'Data'                 => '2012-04-02T10:45:44.000-03:00',
         'DataCredito'          => '2012-04-16T00:00:00.000-03:00',
         'TotalPago'            => '1.00',
         'TaxaParaPagador'      => '0.00',
         'TaxaMoIP'             => '0.46',
         'ValorLiquido'         => '0.56',
         'FormaPagamento'       => 'CartaoDeCredito',
         'InstituicaoPagamento' => 'AmericanExpress',
         'Parcela'              => {'TotalParcelas'=>'1'},
         'Status'               => 'Autorizado',
         'CodigoMoIP'           => '0000.2524.0547' },
        {'Data'                 => '2012-04-02T10:45:44.000-03:00',
         'DataCredito'          => '2012-04-16T00:00:00.000-03:00',
         'TotalPago'            => '10.00',
         'TaxaParaPagador'      => '1.00',
         'TaxaMoIP'             => '0.46',
         'ValorLiquido'         => '0.56',
         'FormaPagamento'       => 'CartaoDeCredito',
         'InstituicaoPagamento' => 'AmericanExpress',
         'Parcela'              => {'TotalParcelas'=>'1'},
         'Status'               => 'Autorizado',
         'CodigoMoIP'           => '0000.1234.5678'} ]
    )

    assert_equal(MyMoip::Transaction, request.transaction('12345678').class)
    assert_equal('0000.1234.5678', request.transaction('12345678').moip_code)
  end

  def test_private_get_transaction_params_when_has_multiple_transactions
    request = MyMoip::ConsultationRequest.new('U260F1E2P0G4N0Z2T1S0M4T3C5E4J5M8L5U0G0I0U0M0H0Y0E3X7S9X6I783')

    VCR.use_cassette('consultation_with_mult_transactions_request') {
      request.api_call
    }

    transaction_params = request.send(:get_transaction_params)
    assert_equal 5, transaction_params.size
    assert_equal Array, transaction_params.class
    assert_equal false, transaction_params.empty?
  end

  def test_private_get_transaction_params_when_has_one_transaction
    request = MyMoip::ConsultationRequest.new('ASDFF1E2P0G4N0Z2T1S0M4T3C5E4J5M8L5U0G0I0U0M0H0Y0E3X759X6ASDF')

    VCR.use_cassette('consultation_with_one_transaction_request') {
      request.api_call
    }

    transaction_params = request.send(:get_transaction_params)
    assert_equal 1, transaction_params.size
    assert_equal Array, transaction_params.class
    assert_equal false, transaction_params.empty?
  end

  def test_private_format_moip_code
    request = MyMoip::ConsultationRequest.new('TOKEN')
    assert_equal '0000.2524.0547', request.send(:format_moip_code, '25240547')
  end
end
