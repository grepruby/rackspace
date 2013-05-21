set :dev_domain,"50.56.250.22" #mobiledev.myhostessapp.com
set :rails_env, "development"
set :deploy_to, "/var/www/mobiledev.myhostessapp.com"
set :repository, "https://svn.growthaccelerationpartners.net/hostess/HostessWeb/branches/development"
#Roles 
role :web, dev_domain
role :app, dev_domain