require File.expand_path('../../test_helper', __FILE__)

class DeviceTokensControllerTest < ActionController::TestCase

  def test_create
    user = User.generate!({})
    json = { device_token: "token1", platform: "ios", key: user.api_key }
    post(:create, json)
    assert_response 200
    assert_not_nil DeviceToken.find_by(token: "token1")
  end

  def test_create_with_invalid_key
    json = { device_token: "token1", platform: "ios", key: "key" }
    post(:create, json)
    assert_response 403
    assert_nil DeviceToken.find_by(token: "token1")
  end

end
