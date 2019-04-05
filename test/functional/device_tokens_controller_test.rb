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

class DeviceTokensControllerTest < ActionController::TestCase

  #
  # test with valid key
  #

  def test_create
    user = User.generate!({})
    json = { device_token: "token1", platform: "ios", key: user.api_key }
    post(:create, json)
    assert_response 200
    assert_not_nil DeviceToken.find_by(token: "token1")
  end

  #
  # test with invalid key
  #

  def test_create_with_invalid_key
    json = { device_token: "token1", platform: "ios", key: "key" }
    post(:create, json)
    assert_response 403
    assert_nil DeviceToken.find_by(token: "token1")
  end

end
