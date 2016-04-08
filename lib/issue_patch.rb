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
# Module IssuePatch enable sending push notifications to various android and ios devices.
#
# When an issue is created or updated, it will invoke the sidekiq worker
# sidekiq worker runs along with redis and perform the task in the background.
#
# Currently push notifications can be sent to ios as well as android
#
# Sidekiq worker requires an array of device tokens as one of the parameter 
# separate for andorid and ios in a hash
#

module IssuePatch
  def self.included(base) 
    base.class_eval do
      after_save :send_push_notification
    end
    base.send(:include, InstanceMethods)
  end

  #
  # IssuePatch module
  # after_save callback is written to send push notification for an issue
  #

  module InstanceMethods

    #
    # method to invoke sidekiq worker
    # unique device tokens and notification message are passed to initialize the sidekiq worker
    #

    def send_push_notification
      users = fetch_users
      device_tokens_hash = pluck_device_tokens_hash(users)
      options = {}
      options[:notification_msg] = notification_msg
      PushNotificationWorker.perform_async(device_tokens_hash, options)
    end

    #
    # fetch assigned user of the issue
    #

    def fetch_assignee
      assigned_to ? [assigned_to] : []
    end

    #
    # fetch watchers if any
    #

    def fetch_watchers
      watcher_users.to_a
    end

    #
    # return an array of users consists of watchers if any along with assinged user
    #

    def fetch_users
      fetch_assignee + fetch_watchers
    end

    #
    # return an hash contaning separate keys for both andorid and ios device tokens
    # collect all users device tokens and assign unique device_tokens to respective keys (android and ios)
    #

    def pluck_device_tokens_hash(users)
      token_hash = {}
      platform_group_tokens = users.flatten.collect{ |user| user.device_tokens }.flatten.group_by(&:platform)
      platform_group_tokens.each do |key, value|
        token_hash["#{key}"] = value.collect(&:token).uniq
      end
      token_hash
    end

    #
    # returns notification message to be sent
    #
    
    def notification_msg
      author_name = author.firstname
      "An issue has been reported by #{author_name}"
    end
  end
end