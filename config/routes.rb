Hostess::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  
  # root route
  root :to => "Admin#design"
  
  # include devise routes
  devise_for :users
  ActiveAdmin.routes(self)

  #Services routes:
  namespace :services do
    #resources :users
    resources :restaurants, :only => [:index, :show] do
      collection do
        get 'near/:position', :action=>'all_near_position', :constraints => {:position => /\-*\d+.?\d*,\-*\d+.?\d*/}
        get 'search', :action=>'search'
        get 'favorites/:udid', :action=>'favorites', :constraints => {:udid => /\w{0,128}/}
        post 'favorites/:udid/:restaurant_id', :action=>'add_to_favorites', :constraints => {:udid => /\w{0,128}/,:special_id => /\d+/}
        delete 'favorites/:udid/:restaurant_id', :action=>'remove_from_favorites', :constraints => {:udid => /\w{0,128}/,:special_id => /\d+/}
        # do not erase this line, this will allow the services to send a message instead of displaying the error page
      end
    end
    resources :specials, :only => [:index, :show] do
      collection do 
        get 'restaurants/:id/:udid', :action=>'list_by_restaurant', :constraints => {:udid => /\w{0,128}/}
        get 'favorites/:udid', :action=>'favorites', :constraints => {:udid => /\w{0,128}/}
        post 'favorites/:udid/:special_id', :action=>'add_to_favorites', :constraints => {:udid => /\w{0,128}/,:special_id => /\d+/}
        delete 'favorites/:udid/:special_id', :action=>'remove_from_favorites', :constraints => {:udid => /\w{0,128}/,:special_id => /\d+/}
        get 'redeem/:udid/:special_id', :action=>'redeem', :constraints => {:udid => /\w{0,128}/,:special_id => /\d+/}
        # do not erase this line, this will allow the services to send a message instead of displaying the error page
      end
    end
    resources :food_categories, :only => [:index]
    resources :notifications, :only => [:register] do 
      collection do 
        get 'register', :action=>'register'
        # do not erase this line, this will allow the services to send a message instead of displaying the error page
      end
    end
    # do not erase this line, this will allow the services to send an error message instead of displaying the old fashion error page
    match '*a', :to=>'errors#routing'
  end
  
  #specific routes
  match 'content/about'
  match 'content/help'  
  match 'content/privacyPolicy'
  match 'content/termsOfService'
  
  match 'admin/design'
  match 'admin/my_info'
  match 'admin/refresh_design'
  match 'admin/specials'
  match 'admin/refresh_special'
  match 'admin/analytics'
 
  match 'admin/signup/step1'
  match 'admin/signup/step2'
  match 'admin/signup/step3'
  match 'admin/signup/thank_you'
  
  match 'account_settings', :controller => "account_settings", :action => "index"
  match 'account_settings/update_name'
  match 'account_settings/update_email'
  match 'account_settings/update_subscription'
  match 'account_settings/update_password'
  match 'account_settings/update_billing_info'
  
end
