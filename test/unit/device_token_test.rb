require File.expand_path('../../test_helper', __FILE__)

class DeviceTokenTest < ActiveSupport::TestCase

  def test_validation
		user = User.generate!({})
  	token = DeviceToken.new(token: "token1", platform: "ios", user: user)
  	token.save
   	assert token.valid?

    token = DeviceToken.new(token: "token1", platform: "ios", user: user)
    token.save
    assert_equal false, token.valid?
  end

  def test_validation_message
		user = User.generate!({})
  	token = DeviceToken.new(token: "token1", platform: "ios", user: user)
  	token.save

    token = DeviceToken.new(token: "token1", platform: "ios", user: user)
    token.save
   	assert_equal ["token has already been taken"], token.errors.full_messages	
  end
end
