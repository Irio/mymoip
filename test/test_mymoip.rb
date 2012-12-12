require 'helper'

class TestMymoip < Test::Unit::TestCase
  def setup
    @default_env = MyMoip.environment
    @default_token = MyMoip.token
    @default_key = MyMoip.key
  end

  def teardown
    MyMoip.environment = @default_env
    MyMoip.token = @default_token
    MyMoip.key = @default_key
  end

  def test_default_environment_is_sandbox
    assert_equal "sandbox", MyMoip.environment
  end

  def test_set_auth_configuration
    MyMoip.token        = "my_token"
    MyMoip.key          = "my_key"
    MyMoip.environment  = "production"
    MyMoip.default_referer_url = "http://localhost"

    assert_equal "my_token", MyMoip.token
    assert_equal "my_key", MyMoip.key
    assert_equal "production", MyMoip.environment
    assert_equal "http://localhost", MyMoip.default_referer_url
  end

  def test_choose_right_api_url_by_sandbox_environment
    MyMoip.environment = "sandbox"

    assert_equal "https://desenvolvedor.moip.com.br/sandbox", MyMoip.api_url
  end

  def test_choose_right_api_url_by_production_environment
    default_env = MyMoip.environment
    MyMoip.environment = "production"

    assert_equal "https://www.moip.com.br", MyMoip.api_url
    MyMoip.environment = default_env
  end

  def test_logger_initialization
    assert MyMoip.logger.instance_of? Logger
  end

  def test_attribution_of_new_logger
    default_logger = MyMoip.logger
    MyMoip.logger = my_string = ""
    assert_equal my_string, MyMoip.logger
    MyMoip.logger = default_logger
  end

  def test_load_sandbox_credentials_from_yaml
    MyMoip.load_config("sandbox:\n  key: yaml_loaded_sandbox_key\n  token: yaml_loaded_sandbox_token")
    assert_equal 'sandbox', MyMoip.environment
    assert_equal 'yaml_loaded_sandbox_key', MyMoip.key
    assert_equal 'yaml_loaded_sandbox_token', MyMoip.token
  end

  def test_load_production_credentials_from_yaml
    MyMoip.load_config("production:\n  key: yaml_loaded_production_key\n  token: yaml_loaded_production_token")
    assert_equal 'production', MyMoip.environment
    assert_equal 'yaml_loaded_production_key', MyMoip.key
    assert_equal 'yaml_loaded_production_token', MyMoip.token
  end
end
