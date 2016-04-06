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

#
# controller to update users device tokens
# stores users device token and device platform info.
#

class DeviceTokensController < ApplicationController
  unloadable
  before_filter :find_user
  accept_api_auth :create

  #
  # make sure to have a current user which is signed_in
  # DeviceToken associated to the current user is created with token and platform info from client params.
  # params = { device_token: "token", platform: "ios" or "android", key: "access key" }
  #
  
  def create
    if @user
      @device_token = DeviceToken.where(user: @user, 
                                        token: params[:device_token], 
                                        platform: params[:platform]).first_or_create
      if @device_token
        render json: { status: 200, msg: "successfull", device_token: @device_token.token }
      else
        render json: { status: 400, msg: "unsuccessfull", errors: @device_token.errors.messages }
      end
    else
      render_403
    end
  end

  private

  #
  # calling redmine method to return current user
  #

  def find_user
    @user = find_current_user
  end

end
