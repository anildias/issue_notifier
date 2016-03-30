# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
require 'sidekiq/web'

RedmineApp::Application.routes.draw do
	post 'users/device_tokens', :to => 'device_tokens#create'

	mount Sidekiq::Web => '/sidekiq'
end