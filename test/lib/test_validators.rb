require_relative '../test_helper'

class TestValidators < Test::Unit::TestCase
  include MyMoip::Validators

  def test_valid_url_validator
  	assert_equal valid_url?('http://valid.url.me'), true
  	assert_equal valid_url?('https://valid.url.me'), true
  	assert_equal valid_url?('ftp://valid.url.me'), false
  	assert_equal valid_url?('valid.url.me'), false
  	assert_equal valid_url?('me'), false
  end
end
