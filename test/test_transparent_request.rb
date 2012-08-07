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

end
