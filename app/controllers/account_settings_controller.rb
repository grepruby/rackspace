class AccountSettingsController < ApplicationController
  
  before_filter :is_user_authenticate
  
  layout 'application'
  
  #before_filter :validate_email, :only=>[:update_email]
  

  #home page for user
  def index
   
  end
  
  def update_name
    if params[:first_name].blank?
      current_user.errors.add("First Name", "can't be blank")
    elsif params[:last_name].blank? 
      current_user.errors.add("Last Name", "can't be blank")
    else
      current_user.update_without_password(:first_name => params[:first_name], :last_name => params[:last_name])  
    end
  end
  
  def update_email
    current_user.update_without_password(:email => params[:new_username], :email_confirmation => params[:new_username_confirmation])
  end
  
  def update_subscription
    if params[:cancelSubscription] == "true"
      User.destroy(current_user)
      sign_out(current_user)
      render(:update) {|page| page.redirect_to("/users/sign_in")}
    end
    
  end
  
  def update_password
    if params[:current_password].blank?
      current_user.errors.add("Current Password", "can't be blank")
    elsif params[:newPassword].blank?
      current_user.errors.add("Password", "can't be blank")
    elsif params[:newPassword_confirmation].blank?
      current_user.errors.add("Password Confirmation", "can't be blank")
    else
      current_user.update_with_password(:current_password=> params[:current_password], :password => params[:newPassword], :password_confirmation => params[:newPassword_confirmation])
      sign_in(current_user, :bypass => true) if current_user.errors.length == 0 
    end
    
  end
  
  def update_billing_info
      current_user.errors.add(:fullname, "Fullname can't be blank.") if params[:fullname].blank?
      current_user.errors.add(:card_type, "Card Type can't be blank.") if params[:card_type].blank?
      current_user.errors.add(:card_number, "Card Number can't be blank.") if params[:card_number].blank?
      current_user.errors.add(:card_number, "CVC code can't be blank.") if params[:cvc].blank?
      current_user.errors.add(:month, "Card expiration month can't be blank.") if params[:month].blank?
      current_user.errors.add(:year, "Card expiration year can't be blank.") if params[:year].blank?
      current_user.errors.add(:billing_address_1, "Billing Address can't be blank.") if params[:billing_address_1].blank?
      current_user.errors.add(:city, "City can't be blank.") if params[:city].blank?
      current_user.errors.add(:state, "State can't be blank.") if params[:state].blank?
      current_user.errors.add(:zip, "Zip can't be blank.") if params[:zip].blank?

      if current_user.errors.empty?
        current_user.billing_information.update_attributes(:full_name => params[:fullname],:billing_address_1 => params[:billing_address_1],
                                                      :billing_address_2 => params[:billing_address_2], :city => params[:city],
                                                      :state_id => params[:state],:zip => params[:zip])
        
        return if current_user.arb_subscription_id.nil?
        
        arb_transaction = AuthorizeNet::ARB::Transaction.new("65Bu23LnR5cZ", "74Je52vFgb6L8w66", :gateway => :production, :test => true)
        credit_card = AuthorizeNet::CreditCard.new(params[:card_number],
                                               params[:month] +  params[:year],
                                               {:card_code=> params[:cvc], :card_type => params[:card_type]})
        subscription = AuthorizeNet::ARB::Subscription.new(
                            :subscription_id => current_user.arb_subscription_id,
                            :credit_card => credit_card,
                            :customer => AuthorizeNet::Customer.new(:email => current_user.email, :ip => request.remote_ip),
                            :billing_address => AuthorizeNet::Address.new(:first_name => current_user.first_name,
                                                                          :last_name => current_user.last_name,
                                                                          :city => params[:city],
                                                                          :state => State.find_by_id(params[:state]).name,
                                                                          :zip => params[:zip],
                                                                          :street_address => params[:billing_address_1] + ", " + params[:billing_address_2]))
                                                                          
        response = arb_transaction.update(subscription)
        unless response.success?
          if response.message_code == "E00003"
            current_user.errors.add(:arbr, "The Credit Card info is incorrect") unless response.success?
          else
            current_user.errors.add(:arbr, response.message_text) unless response.success?  
          end
        else
          current_user.arb_status = AuthorizeNet::ARB::Subscription::Status::ACTIVE
          current_user.save              
        end
        
        
      end
  end
  
  private

  #validate is a user log in
  def is_user_authenticate
    redirect_to '/users/sign_in' if current_user.nil?
  end
  
end