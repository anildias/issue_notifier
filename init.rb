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

User.send(:include, UserPatch)
Issue.send(:include, IssuePatch)

# to include workers directory
Dir.glob(File.join(Redmine::Plugin.directory, '*')).sort.each do |directory|
  if File.directory?(directory)
    workers = File.join(directory, 'app', 'workers')
    if File.directory?(workers)
      ActiveSupport::Dependencies.autoload_paths += [workers]
    end
  end
end

# delay is used as an attribute in redmine AR
Sidekiq.remove_delay! 