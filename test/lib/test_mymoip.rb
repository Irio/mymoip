require_relative '../test_helper'

class TestMymoip < Test::Unit::TestCase
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

  def test_default_environment_is_sandbox
    MyMoip.environment = 'sandbox'
    assert_equal "sandbox", MyMoip.environment
  end

  def test_key_setter_updates_sandbox_and_production_keys
    MyMoip.key = "my_key"
    assert_equal "my_key", MyMoip.production_key
    assert_equal "my_key", MyMoip.sandbox_key
  end

  def test_token_setter_updates_sandbox_and_production_tokens
    MyMoip.token = "my_token"
    assert_equal "my_token", MyMoip.production_token
    assert_equal "my_token", MyMoip.sandbox_token
  end

  def test_current_auth_when_in_sandbox
    MyMoip.sandbox_key   = "sandbox_key"
    MyMoip.sandbox_token = "sandbox_token"
    MyMoip.environment   = "sandbox"
    assert_equal "sandbox_key", MyMoip.key
    assert_equal "sandbox_token", MyMoip.token
  end

  def test_current_auth_when_in_production
    MyMoip.production_key   = "production_key"
    MyMoip.production_token = "production_token"
    MyMoip.environment      = "production"
    assert_equal "production_key", MyMoip.key
    assert_equal "production_token", MyMoip.token
  end

  def test_default_referer_url_setter
    MyMoip.default_referer_url = "http://localhost"
    assert_equal "http://localhost", MyMoip.default_referer_url
  end

  def test_environment_setter
    MyMoip.environment = "production"
    assert_equal "production", MyMoip.environment
  end

  def test_choose_right_api_url_by_sandbox_environment
    MyMoip.environment = "sandbox"
    assert_equal "https://desenvolvedor.moip.com.br/sandbox", MyMoip.api_url
  end

  def test_choose_right_api_url_by_production_environment
    default_env = MyMoip.environment
    MyMoip.environment = "production"
    assert_equal "https://www.moip.com.br", MyMoip.api_url
  end

  def test_logger_initialization
    assert MyMoip.logger.instance_of?(Logger)
  end

  def test_attribution_of_new_logger
    default_logger = MyMoip.logger
    MyMoip.logger = my_string = ""
    assert_equal my_string, MyMoip.logger
  end
end
