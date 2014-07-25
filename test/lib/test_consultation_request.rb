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

  def test_transactions_when_response_has_multiple_transactions
    request = MyMoip::ConsultationRequest.new('U260F1E2P0G4N0Z2T1S0M4T3C5E4J5M8L5U0G0I0U0M0H0Y0E3X7S9X6I783')

    VCR.use_cassette('consultation_with_mult_transactions_request') {
      request.api_call
    }

    assert_equal 5, request.transactions.length
    assert_equal Array, request.transactions.class
    assert_equal false, request.transactions.empty?
  end

  def test_transactions_when_response_has_one_transaction
    request = MyMoip::ConsultationRequest.new('ASDFF1E2P0G4N0Z2T1S0M4T3C5E4J5M8L5U0G0I0U0M0H0Y0E3X759X6ASDF')

    VCR.use_cassette('consultation_with_one_transaction_request') {
      request.api_call
    }

    assert_equal 1, request.transactions.length
    assert_equal Array, request.transactions.class
    assert_equal false, request.transactions.empty?
  end

  def test_find_a_transaction_by_formatted_moip_code_on_transactions_list
    request = MyMoip::ConsultationRequest.new('TOKEN')

    request.stubs(:transactions).returns(
      [{ moip_code: '0000.2524.0547' }, { moip_code: '0000.1234.0547'}]
    )

    transaction = request.transaction('12340547')
    assert_equal({ moip_code: '0000.1234.0547'}, transaction)
  end

  def test_private_format_moip_code
    request = MyMoip::ConsultationRequest.new('TOKEN')
    assert_equal '0000.2524.0547', request.send(:format_moip_code, '25240547')
  end
end
