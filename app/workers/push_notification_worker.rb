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
# Sidekiq worker class to process pushnotification asynchronously.
# handles android and ios devices seperatly
#
# to send push notifications to android, gcm service is used
# gcm_api_key should be obtained from google console
#
# for sending ios push notifications, apns is used
# pem.cert file should be obtained
#
# Make sure to add following lines to redmine/cofig/settings.yml
#
# gcm:
#   api_key: ** your api key **
# apns:
#   host: "gateway.push.apple.com"
#   pem: "full_path/to/cert.pem"
# 

require 'gcm'
require 'apns'

class PushNotificationWorker
  include Sidekiq::Worker

  # 
  # sidekiq worker
  # invoke two methods to send notifications to android and ios devices.
  #

  def perform(tokens_hash, options)
    push_to_android(tokens_hash['android'], options)
    push_to_ios(tokens_hash['ios'], options)
  end

  #
  # method sending push notifications to android devices
  # initialize GCM with API_KEY
  #

  def push_to_android(device_tokens, options)
    if device_tokens
      gcm = GCM.new(GCM_API_KEY)
      response = gcm.send(device_tokens, 
                            { data: { message: options["notification_msg"] } }
                         )
    end
  end

  #
  # method sending push notifications to ios devices
  # loop over each device tokens
  #
  
  def push_to_ios(device_tokens, options)
    if device_tokens
      device_tokens.each do |device_token|
        APNS.send_notification(device_token,
                                :alert => options["notification_msg"],
                                :sound => 'default',
                                :other => {}
                              )
      end
    end
  end
end