# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Hostess::Application.initialize!

#host specification
default_url_options = { :host => 'http://mobilepreview.myhostessapp.com' }

#ActionMailer::Base.smtp_settings = {
#:user_name => "hostess",
#:password => "H0st3ss#G4P!",
#:domain => "http://mobile.myhostessapp.com",
#:address => "smtp.sendgrid.net",
#:port => 587,
#:authentication => :plain,
#:enable_starttls_auto => true
#}

