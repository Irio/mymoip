require_relative '../test_helper'

class TestRequest < Test::Unit::TestCase
  def setup
    @default_environment = MyMoip.environment
    @default_key         = MyMoip.key
    @default_token       = MyMoip.token
    @default_logger      = MyMoip.logger
  end

  def teardown
    MyMoip.environment = @default_environment
    MyMoip.key         = @default_key
    MyMoip.token       = @default_token
    MyMoip.logger      = @default_logger
  end

  def test_initializes_receiving_data_and_optional_id
    request = MyMoip::Request.new("request_id")
    assert_equal "request_id", request.id
  end

  def test_logs_api_call_method_in_info_level
    logger = stub_everything
    request = MyMoip::Request.new("request_id")
    params = {
      http_method: :post, body: "<pretty><xml></xml></pretty>", path: "/ws/alpha/EnviarInstrucao/Unica"
    }

    HTTParty.stubs(:send).returns("<html>some_result</html>")
    logger.expects(:info).at_least_once.
      with(regexp_matches(/being sent to MoIP/))

    request.api_call(params, logger: logger)
  end

  def test_logs_api_call_method_parameters_in_debug_level
    logger = stub_everything
    request = MyMoip::Request.new("request_id")
    params = {
      http_method: :post, body: "<pretty><xml></xml></pretty>", path: "/ws/alpha/EnviarInstrucao/Unica"
    }

    HTTParty.stubs(:send).returns("<html>some_result</html>")
    logger.expects(:debug).at_least_once.
      with(regexp_matches(/request_id.+<pretty><xml><\/xml><\/pretty>/))

    request.api_call(params, logger: logger)
  end

  def test_logs_api_call_response_in_debug_level
    logger = stub_everything
    request = MyMoip::Request.new("request_id")
    params = {
      http_method: :post, body: "<pretty><xml></xml></pretty>", path: "/ws/alpha/EnviarInstrucao/Unica"
    }

    HTTParty.stubs(:send).returns("<html>some_result</html>")
    logger.expects(:debug).at_least_once.
      with(regexp_matches(/request_id.+<html>some_result<\/html>/))

    request.api_call(params, logger: logger)
  end

  def test_raises_error_before_api_calls_without_a_key_set
    subject = MyMoip::Request.new('request_id')
    MyMoip.sandbox_key = nil
    assert_raises StandardError do
      subject.api_call({})
    end
    MyMoip.sandbox_key = ''
    assert_raises StandardError do
      subject.api_call({})
    end
  end

  def test_raises_error_before_api_calls_without_a_token_set
    subject = MyMoip::Request.new('request_id')
    MyMoip.sandbox_token = nil
    assert_raises StandardError do
      subject.api_call({})
    end
    MyMoip.sandbox_token = ''
    assert_raises StandardError do
      subject.api_call({})
    end
  end
end
