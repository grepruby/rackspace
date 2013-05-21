set :prod_domain, "108.166.72.152" #"mobile.myhostessapp.com"
set :rails_env, "production"
set :deploy_to, "/var/www/mobile.myhostessapp.com"
set :repository, "https://svn.growthaccelerationpartners.net/hostess/HostessWeb/trunk"

#Roles 
role :web, prod_domain
role :app, prod_domain