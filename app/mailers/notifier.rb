class Notifier < ActionMailer::Base
  
  default :from => "Hostess Marketing <no-reply@myhostessapp.com>"
  
  def welcome_message(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>",
         :subject=>"Welcome to Hostess!", :bcc=>"new@myhostessapp.com")
  end
  
end