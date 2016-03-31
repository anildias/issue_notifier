#
# controller to update users device tokens
# stores users device token and device platform info.

class DeviceTokensController < ApplicationController
  unloadable
  before_filter :find_user
  accept_api_auth :create

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
  def find_user
  	@user = find_current_user
  end

end
