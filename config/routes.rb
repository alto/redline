ActionController::Routing::Routes.draw do |map|

  map.activate          'activate/:activation_code', :controller => 'users', :action => 'activate'
  map.recover_password  '/users/recover_password',   :controller => 'users', :action => 'recover_password'

  map.resource :session
  map.resources :users

  map.root :controller => "home"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
