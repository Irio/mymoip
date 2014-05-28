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

  def test_should_provide_the_xml_str_get_by_the_request
    request = MyMoip::ConsultationRequest.new('U260F1E2P0G4N0Z2T1S0M4T3C5E4J5M8L5U0G0I0U0M0H0Y0E3X7S9X6I783')

    VCR.use_cassette('consultation_request') { request.api_call }

    assert_block { request.xml_str.match(/^<ns1:ConsultarTokenResponse/) }
  end
end
