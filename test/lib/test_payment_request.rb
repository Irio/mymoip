# encoding: UTF-8
require_relative '../test_helper'

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

  def test_successful_status
    MyMoip.default_referer_url = "http://localhost/default"
    HTTParty.stubs(:send).returns(
      JSON.parse '{"Status":"EmAnalise","Codigo":0,"CodigoRetorno":"","TaxaMoIP":"7.79","StatusPagamento":"Sucesso","Classificacao":{"Codigo":999,"Descricao":"Não suportado no ambiente Sandbox"},"CodigoMoIP":77316,"Mensagem":"Requisição processada com sucesso","TotalPago":"100.00"}'
    )
    request = MyMoip::PaymentRequest.new("id")

    request_data = stub(to_json: {payment: "attributes"})
    request.api_call(request_data, token: "big_transparent_token")
    assert request.success?
  end

  def test_success_method_returns_false_in_payments_already_made
    MyMoip.default_referer_url = "http://localhost/default"
    HTTParty.stubs(:send).returns(
      JSON.parse '{"Codigo":236,"StatusPagamento":"Falha","Mensagem":"Pagamento já foi realizado"}'
    )
    request = MyMoip::PaymentRequest.new("id")

    request_data = stub(to_json: {payment: "attributes"})
    request.api_call(request_data, token: "big_transparent_token")
    assert !request.success?
  end

  def test_method_to_get_moip_code
    make_a_successfully_payment
    assert_equal 102596, @payment_request.code
  end

  def test_method_to_get_status
    make_a_successfully_payment
    assert_equal 6, @payment_request.status
  end

  def test_method_to_get_total_payed
    make_a_successfully_payment
    assert_equal '200.00', @payment_request.total_payed
  end

  def test_code_method_should_return_nil_with_blank_response
    payment_request = MyMoip::PaymentRequest.new("your_own_id")
    assert_nil payment_request.code
  end

  def test_status_method_should_return_nil_with_blank_response
    payment_request = MyMoip::PaymentRequest.new("your_own_id")
    assert_nil payment_request.status
  end

  def test_total_payed_method_should_return_nil_with_blank_response
    payment_request = MyMoip::PaymentRequest.new("your_own_id")
    assert_nil payment_request.total_payed
  end

  def test_method_to_get_response_url
    make_a_successfully_payment
    assert_equal "https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token=#{@transparent_request.token}", @payment_request.url
  end

  def test_url_method_should_return_nil_with_blank_response
    instruction = Fixture.instruction(payer: Fixture.payer)
    transparent_request = MyMoip::TransparentRequest.new("your_own_id")
    VCR.use_cassette('transparent_request') do
      transparent_request.api_call(instruction)
    end
    payment_request = MyMoip::PaymentRequest.new("your_own_id")
    assert_nil payment_request.url
  end

  def make_a_successfully_payment
    instruction = Fixture.instruction(payer: Fixture.payer)
    @transparent_request = MyMoip::TransparentRequest.new("your_own_id")
    VCR.use_cassette('transparent_request') do
      @transparent_request.api_call(instruction)
    end
    credit_card_payment = MyMoip::CreditCardPayment.new(Fixture.credit_card, installments: 1)
    @payment_request = MyMoip::PaymentRequest.new("your_own_id")
    VCR.use_cassette('payment_request') do
      @payment_request.api_call(credit_card_payment, token: @transparent_request.token)
    end
  end
end
