require 'helper'

class TestRequest < Test::Unit::TestCase
  def test_initializes_receiving_data_and_optional_id
    request = MyMoip::Request.new("request_id")
    assert_equal "request_id", request.id
  end

  def test_logs_api_call_method
    logger = mock()
    request = MyMoip::Request.new("request_id")
    logger.expects(:info).with(regexp_matches(/request_id.+some.+data/))
    request.api_call({some: "data"}, logger)
  end
end
