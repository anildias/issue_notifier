# Sidekiq worker class to process pushnotification asynchronously.
# handles android and ios devices seperatly

# to send push notifications to android, gcm service is used
# gcm_api_key should be obtained form google and set the values in ENV['gcm_api_key']

# for sending ios push notifications, apns is used
# pem file should be generated and placed
# set APNS.host and APNS.pem

require 'gcm'
require 'apns'

class PushNotificationWorker
  include Sidekiq::Worker
  def perform(tokens_hash, options)
    push_to_android(tokens_hash['android'], options)
    push_to_ios(tokens_hash['ios'], options)
  end

  def push_to_android(device_tokens, options)
    gcm = GCM.new(ENV['gcm_api_key'])
    response = gcm.send(device_tokens, 
                        { data: { message: options["notification_msg"] } }
                      )
  end

  def push_to_ios(device_tokens, options)
    device_tokens.each do |device_token|
      APNS.send_notification(device_token,
                              :alert => options["notification_msg"],
                              :sound => 'default',
                              :other => {}
                            )
    end
  end
end