require 'capistrano/ext/multistage'

# general settings
set :application, "hostess"
set :use_sudo, false
set :default_stage, "dev"
set :stages, %w(dev preview production)


# Login user for ssh.
set :user, "buildmaster"
set :runner, user
set :admin_runner, user

#login user for subversion 
set :scm, :subversion    # :subversion or :git
set :scm_username, "buildmaster"
set :scm_password, "H0st3ss#G4P!" 
set :checkout, "export"

# server options
set :app_server, :passenger
set :keep_releases, 5


# Passenger mod_rails
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end

after :deploy, :delete_svn_files
task :delete_svn_files do
   run "cd #{deploy_to}/current/ && #{try_sudo} ruby delete_subversion_files.rb"
end