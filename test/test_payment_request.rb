require 'helper'

class TestPaymentRequest < Test::Unit::TestCase

  def test_http_method_as_get
    assert_equal :get, MyMoip::PaymentRequest::HTTP_METHOD
  end

  def test_path
    assert_equal  "/rest/pagamento?callback=?", MyMoip::PaymentRequest::PATH
  end

  def test_non_auth_requirement
    assert_equal false, MyMoip::PaymentRequest::REQUIRES_AUTH
  end

  def test_generate_json
    HTTParty.stubs(:send).returns("<html>some_result</html>")
    request = MyMoip::PaymentRequest.new("id")

    JSON.expects(:generate).with(
      pagamentoWidget: {
        referer: "http://localhost",
        token:   "big_transparent_token",
        dadosPagamento: {payment: "attributes"}
      }
    )
    request_data = stub(to_json: {payment: "attributes"})
    request.api_call(request_data, token: "big_transparent_token", referer_url: "http://localhost")
  end

  def test_gets_default_referer_if_another_isnt_passed
    MyMoip.default_referer_url = "http://localhost/default"
    HTTParty.stubs(:send).returns("<html>some_result</html>")
    request = MyMoip::PaymentRequest.new("id")

    JSON.expects(:generate).with(
      pagamentoWidget: {
        referer:        MyMoip.default_referer_url,
        token:          "big_transparent_token",
        dadosPagamento: {payment: "attributes"}
      }
    )
    request_data = stub(to_json: {payment: "attributes"})
    request.api_call(request_data, token: "big_transparent_token")
  end

end
