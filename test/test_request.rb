require 'helper'

class TestRequest < Test::Unit::TestCase
  def test_initializes_receiving_data_and_optional_id
    request = MyMoip::Request.new("request_id")
    assert_equal "request_id", request.id
  end

  def test_logs_api_call_method
    logger = stub_everything
    request = MyMoip::Request.new("request_id")
    params = {
      http_method: :post, body: "<pretty><xml></xml></pretty>", path: "/ws/alpha/EnviarInstrucao/Unica"
    }

    HTTParty.stubs(:send).returns("<html>some_result</html>")
    logger.expects(:info).at_least_once.
      with(regexp_matches(/request_id.+<html>some_result<\/html>/))

    request.api_call(params, logger: logger)
  end

  def test_logs_api_call_response
    logger = stub_everything
    request = MyMoip::Request.new("request_id")
    params = {
      http_method: :post, body: "<pretty><xml></xml></pretty>", path: "/ws/alpha/EnviarInstrucao/Unica"
    }

    HTTParty.stubs(:send).returns("<html>some_result</html>")
    logger.expects(:info).at_least_once.
      with(regexp_matches(/request_id.+<html>some_result<\/html>/))

    request.api_call(params, logger: logger)
  end

end
