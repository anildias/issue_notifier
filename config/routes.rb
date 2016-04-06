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

# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

require 'sidekiq/web'

RedmineApp::Application.routes.draw do
  post 'users/device_tokens', :to => 'device_tokens#create'

  mount Sidekiq::Web => '/sidekiq'
end