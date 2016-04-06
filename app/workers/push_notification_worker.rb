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
  # sidekiq worker perform method
  # invoke two methods to send notifications to android and ios
  #

  def perform(tokens_hash, options)
    push_to_android(tokens_hash['android'], options)
    push_to_ios(tokens_hash['ios'], options)
  end

  #
  # method send push notifications to android devices
  # initialze GCM with API_KEY
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
  # method send push notifications to ios devices
  # loop over each device token and APNS is invoked
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