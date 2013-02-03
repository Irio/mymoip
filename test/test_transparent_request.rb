require 'helper'

class TestTransparentRequest < Test::Unit::TestCase
  def test_http_method_as_post
    assert_equal :post, MyMoip::TransparentRequest::HTTP_METHOD
  end

  def test_path
    assert_equal "/ws/alpha/EnviarInstrucao/Unica", MyMoip::TransparentRequest::PATH
  end

  def test_auth_requirement
    assert_equal true, MyMoip::TransparentRequest::REQUIRES_AUTH
  end

  def test_success_method_with_valid_json
    HTTParty.stubs(:send).returns(
      {"EnviarInstrucaoUnicaResponse"=>{"xmlns:ns1"=>"http://www.moip.com.br/ws/alpha/", "Resposta"=>{"ID"=>"201208081614306080000000928569", "Status"=>"Sucesso", "Token"=>"G290E1H230N8L0M8J1K6F1F4B3T0N610K8B0S0H0I0T0T0E029Y2R8H5Y6H9"}}}
    )
    request = MyMoip::TransparentRequest.new("some_id")
    request_data = stub(to_xml: "<anydata></anydata>")
    request.api_call request_data
    assert request.success?
  end

  def test_success_method_with_failed_response
    HTTParty.stubs(:send).returns(
      {"EnviarInstrucaoUnicaResponse"=>{"xmlns:ns1"=>"http://www.moip.com.br/ws/alpha/", "Resposta"=>{"Status"=>"Falha"}}}
    )
    request = MyMoip::TransparentRequest.new("some_id")
    request_data = stub(to_xml: "<anydata></anydata>")
    request.api_call request_data
    assert !request.success?
  end

  def test_success_method_with_requests_that_hasnt_be_made
    request = MyMoip::TransparentRequest.new("some_id")
    assert !request.success?
  end

  def test_provides_token_when_has_a_valid_response
    HTTParty.stubs(:send).returns(
      {"EnviarInstrucaoUnicaResponse"=>{"xmlns:ns1"=>"http://www.moip.com.br/ws/alpha/", "Resposta"=>{"ID"=>"201208081614306080000000928569", "Status"=>"Sucesso", "Token"=>"token"}}}
    )
    request = MyMoip::TransparentRequest.new("some_id")
    request_data = stub(to_xml: "<anydata></anydata>")
    request.api_call request_data
    assert_equal "token", request.token
  end

  def test_provides_token_with_requests_that_hasnt_be_made
    request = MyMoip::TransparentRequest.new("some_id")
    assert_equal nil, request.token
  end

  def test_should_provide_the_transaction_id_get_by_the_request
    request = MyMoip::TransparentRequest.new("some_id")
    VCR.use_cassette('transparent_request') do
      request.api_call(Fixture.instruction(payer: Fixture.payer))
    end
    assert_equal "201210171118501100000001102691", request.id
  end

  def test_should_provide_the_transaction_id_get_by_the_request_with_commissions_feature
    request = MyMoip::TransparentRequest.new("some_id")
    VCR.use_cassette('transparent_request_with_commissions') do
      request.api_call Fixture.instruction(commissions: [Fixture.commission])
    end
    assert_equal "YOUR_REQUEST_ID", request.id
  end
end
