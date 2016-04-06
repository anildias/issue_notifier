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
# extend User class to have a one-to-many relationship with DeviceToken
# extend Issue class to execute worker to send push notification when an issue has been reported or changed.
#

require 'user_patch'
require 'issue_patch'

Redmine::Plugin.register :issue_notifier do
  name 'Issue Notifier plugin'
  author 'Anil Dias'
  description 'A Redmine Plugin to notify assignee and watchers through push notification when an issue has been reported.'
  version '0.0.1'
  url ''
  author_url 'https://github.com/anildias'
  menu :top_menu, :Sidekiq_Dashboard, '/sidekiq', :if => Proc.new {User.current.admin}
end

#
# setting APNS host and pem varibles
# GCM_API_KEY is initialized
#

setting = YAML.load( File.open('config/settings.yml') )
GCM_API_KEY = setting['gcm']['api_key']
APNS.host = setting['apns']['host'] 
APNS.pem = setting['apns']['pem']

#
# include UserPatch and IssuePatch modules
#
User.send(:include, UserPatch)
Issue.send(:include, IssuePatch)

#
# to include workers directory
#

Dir.glob(File.join(Redmine::Plugin.directory, '*')).sort.each do |directory|
  if File.directory?(directory)
    workers = File.join(directory, 'app', 'workers')
    if File.directory?(workers)
      ActiveSupport::Dependencies.autoload_paths += [workers]
    end
  end
end

#
# delay is used as an attribute in redmine AR
#

Sidekiq.remove_delay! 