require 'helper'

class TestMymoip < Test::Unit::TestCase

  def test_default_environment_is_sandbox
    assert_equal "sandbox", MyMoip.environment
  end

  def test_set_auth_configuration
    MyMoip.token        = "my_token"
    MyMoip.key          = "my_key"
    MyMoip.environment  = "production"

    assert_equal "my_token", MyMoip.token
    assert_equal "my_key", MyMoip.key
    assert_equal "production", MyMoip.environment
  end

  def test_choose_right_api_url_by_sandbox_environment
    MyMoip.environment = "sandbox"

    assert_equal "https://desenvolvedor.moip.com.br/sandbox", MyMoip.api_url
  end

  def test_choose_right_api_url_by_production_environment
    MyMoip.environment = "production"

    flunk 'Search and set default url for production'
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

end
