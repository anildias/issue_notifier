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
require 'sidekiq/testing'

Sidekiq::Testing.fake!

class IssuePatchTest < ActiveSupport::TestCase

  #
  # test worker to enque a job when issue has been updated or created
  #

  def test_issue_creation_should_enque_job
    assert_difference "PushNotificationWorker.jobs.size", +1 do
      issue = Issue.generate!({})
    end
  end

  #
  # test worker directly
  #

  def test_worker
    assert_difference "PushNotificationWorker.jobs.size", +1 do
      options = {}
      options[:notifications_msg] = ""
      device_tokens_hash = {"ios" => [], "android" => []}
      PushNotificationWorker.perform_async(device_tokens_hash, options)
    end
  end
end