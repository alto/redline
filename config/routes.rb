ActionController::Routing::Routes.draw do |map|

  map.activate          'activate/:activation_code', :controller => 'users', :action => 'activate'
  map.recover_password  '/users/recover_password',   :controller => 'users', :action => 'recover_password'
  
  map.search 'search', :controller => 'search', :action => 'search'

  map.resource :session
  map.resources :users
  map.resources :claims
  map.resources :people
  map.resources :connections

  map.root :controller => "home"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
