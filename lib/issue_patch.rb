# Module IssuePatch enable sending push notifications to various android and ios devices.

# When an issue is created or updated, it will invoke the sidekiq worker
# sidekiq worker runs along with redis and perform the task in the background.

# Currently push notifications can be sent to ios as well as android

# Sidekiq worker requires an array of device tokens as one of the parameter 
# separate for andorid and ios in a hash

module IssuePatch
  def self.included(base)
    # Same as typing in the class 
    base.class_eval do
      # unloadable # Send unloadable so it will not be unloaded in development
      after_save :send_push_notification
    end
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def send_push_notification
      users = fetch_users
      device_tokens_hash = pluck_device_tokens_hash(users)
      options = {}
      options[:notification_msg] = notification_msg
      PushNotificationWorker.perform_async(device_tokens_hash, options)
    end

    def fetch_assignee
      assigned_to
    end

    def fetch_watchers
      watcher_users.to_a
    end

    def fetch_users
      [fetch_assignee] + fetch_watchers
    end

    def pluck_device_tokens_hash(users)
      token_hash = {}
      platform_group_tokens = users.flatten.collect{ |user| user.device_tokens }.flatten.group_by(&:platform)
      platform_group_tokens.each do |key, value|
        token_hash["#{key}"] = value.collect(&:token)
      end
      token_hash
    end

    def notification_msg
      author_name = author.firstname
      "An issue has been reported by #{author_name}"
    end
  end
end