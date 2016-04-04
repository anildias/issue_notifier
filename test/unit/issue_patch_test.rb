require File.expand_path('../../test_helper', __FILE__)
require 'sidekiq/testing'

Sidekiq::Testing.fake!

class IssuePatchTest < ActiveSupport::TestCase

  def test_issue_creation_should_enque_job
    assert_difference "PushNotificationWorker.jobs.size", +1 do
      issue = Issue.generate!({})
    end
  end

  def test_worker
    assert_difference "PushNotificationWorker.jobs.size", +1 do
      options = {}
      options[:notifications_msg] = ""
      device_tokens_hash = {"ios" => [], "android" => []}
      PushNotificationWorker.perform_async(device_tokens_hash, options)
    end
  end
end