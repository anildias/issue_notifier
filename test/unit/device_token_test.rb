=begin

Apache License

Version 2.0, January 2004

Copyright (c) 2016 QBurst Technologies Inc.

Licensed under the Apache License, Version 2.0 (the "License"); 
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, 
software distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
either express or implied.
 
See the License for the specific language governing permissions and limitations under the License.

=end

require File.expand_path('../../test_helper', __FILE__)

class DeviceTokenTest < ActiveSupport::TestCase

  #
  # test DeviceToken validation
  #

  def test_validation
    user = User.generate!({})
    token = DeviceToken.new(token: "token1", platform: "ios", user: user)
    token.save
    assert token.valid?

    token = DeviceToken.new(token: "token1", platform: "ios", user: user)
    token.save
    assert_equal false, token.valid?
  end

  #
  # test DeviceToken invalidate message to be shown
  #

  def test_validation_message
    user = User.generate!({})
    token = DeviceToken.new(token: "token1", platform: "ios", user: user)
    token.save

    token = DeviceToken.new(token: "token1", platform: "ios", user: user)
    token.save
    assert_equal ["token has already been taken"], token.errors.full_messages	
  end
end
