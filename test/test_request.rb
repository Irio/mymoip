require 'helper'

class TestRequest < Test::Unit::TestCase
  def test_initialize_receiving_instruction_data_and_optional_id
    request = MyMoip::Request.new(:transparent, id: "request_id", data: { some: "random_data" })
    assert_equal :transparent, request.instruction
    assert_equal "request_id", request.id
    assert_equal ({ some: "random_data" }), request.data
  end

  def test_raises_exception_in_case_of_no_data_provided_on_initializer
    assert_raise ArgumentError do
      request = MyMoip::Request.new(:transparent, id: "request_id")
    end
  end
end
