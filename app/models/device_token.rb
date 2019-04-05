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
# Model DeviceToken handles token and device platform info
# Maintains belongs_to association with User class
#

class DeviceToken < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :token, :scope => [:user_id, :platform]
  validate :device_type

  ALLOWED_DEVICES = ["ios", "android"]

  def self.init(params, user)
    token = DeviceToken.new(  user_id: user.id, 
                              token: params[:device_token], 
                              platform: params[:platform] )
  end

  def device_type
    if platform.present?
      unless ALLOWED_DEVICES.include?(platform)
        errors.add(:platform, 'Invalid device type, - platform parameter - 
                                allowed only ios and android')
      end
    else
      errors.add(:platform, 'specify device type - platform parameter - 
                              allowed only ios and android')
    end
  end
end
