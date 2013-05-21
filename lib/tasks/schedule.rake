namespace :schedule do
  task :send_about_expire_notifications => :environment do
    Special.send_expire_notification
  end
  
  task :update_user_arb_status => :environment do
    User.update_arb_status
  end
  
end