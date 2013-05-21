set :pre_domain, "50.56.250.22" #"mobilepreview.myhostessapp.com"
set :rails_env, "preview"
set :deploy_to, "/var/www/mobilepreview.myhostessapp.com"
set :repository, "https://svn.growthaccelerationpartners.net/hostess/HostessWeb/branches/preview"
#Roles 
role :web, pre_domain
role :app, pre_domain