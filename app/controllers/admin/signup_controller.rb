class Admin::SignupController < ApplicationController

  require 'rubygems'
  require 'authorize_net'

  layout 'application'

  # filter to validate the data from previus step
  before_filter :check_data_for_step_1, :only => :step1
  before_filter :check_data_for_step_2, :only => :step2
  before_filter :check_data_for_step_3, :only => :step3
  
  #before_filter :check_data_for_step_4, :only => :thank_you

  #
  # step 1, nothing to validate
  #
  def step1

  end

  #
  # step 2
  # All the user personal information is required, any fault return to step1
  # Create the user that will be save in session and removed in the last step
  #
  def step2
    user = User.new
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.email = params[:username]
    user.email_confirmation = params[:username_confirmation]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    session[:user] = user
    if user.valid?
      session[:errors] = nil
    else
      session[:errors] = user.errors
      redirect_to admin_signup_step1_path
    end
  end

  #
  # step 3
  # The subscription value is required
  # Save in the user session the subscription that he/she choose
  # Collect all payment info
  #
  def step3
    user = session[:user]
    #for v1, always this will be the subscription basic 18$, for v2 this will change
    user.subscription_id = 1
  end

  #
  # step 4 or Thank you page
  # The payment info is required, any error return to step 3
  # This step create the transaction and show the result
  #
  # Production
  # Current API Login ID: 65Bu23LnR5cZ
  # Current Transaction Key:  74Je52vFgb6L8w66
  #
  # Developer
  # API Login ID 346cAwK8
  # Transaction Key 4W23eD78pR4DkHP2
  #
  # For your reference, you can use the following test credit card numbers.
  # The expiration date must be set to the present date or later. Use 123 for the CCV code.
  # American Express 370000000000002
  # Discover 6011 0000 0000 0012
  # Visa 4007 0000 00027
  # JCB 3088000000000017
  # Diners Club/ Carte Blanche 38000000000006

  def thank_you
    user = User.new
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.email = params[:username]
    user.email_confirmation = params[:username_confirmation]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    session[:user] = user
    if user.valid?
      session[:errors] = nil
      user.save
    else
      session[:errors] = user.errors
      redirect_to admin_signup_step1_path
    end 
  
    # user = session[:user]
    # user.zip = params[:zip]
    
    # start_date = Date.today
    # start_date += 61
    
    # response = create_autorrecuring_subscription(start_date, user, params[:card_number], params[:month], params[:year], 
    #                                               params[:cvc], params[:card_type], params[:city], params[:state],
    #                                               params[:billing_address_1], params[:billing_address_2])
    # if response.success?
    #     session[:errors] = nil
    #     session[:user] = nil
    #     user.arb_subscription_id = response.subscription_id
    #     user.arb_status = AuthorizeNet::ARB::Subscription::Status::ACTIVE
    #     user.billing_information_id = user.add_billing_information(params[:fullname], params[:billing_address_1] ,
    #                                                                params[:billing_address_2], params[:city], params[:state],
    #                                                                params[:zip]).id
    #     user.save
    #   else
    #     puts "Failed to make purchase. " + response.response_reason_code + " - " + response.response_reason_text
    #     user.errors.clear()
    #     user.errors.add(:transaction, response.response_reason_text)
    #     session[:errors] = user.errors
    #     redirect_to admin_signup_step3_path
    #   end 

    
  end

  private

  def check_data_for_step_1
    if (session[:user].nil? and !session[:errors].nil?) or (!session[:user].nil? and session[:errors].nil?)
    session[:user] = nil
    session[:errors] = nil
    end
  end

  def check_data_for_step_2
    if (session[:user].nil? and !session[:errors].nil?) or (!session[:user].nil? and session[:errors].nil?)
      session[:user] = nil
      session[:errors] = nil
      redirect_to admin_signup_step1_path
    end
  end
  

  def check_data_for_step_3
   #if request.ssl?
      if session[:user].nil? and session[:errors].nil?
        session[:user] = nil
        redirect_to admin_signup_step1_path, :protocol => "http://"
      end
   #else
   #   redirect_to admin_signup_step1_path, :protocol => "http://"    
   #end
  end

  def check_data_for_step_4
    if session[:user].nil?
      redirect_to admin_signup_step1_path
    else
      user = session[:user]
      user.errors.clear()
      user.errors.add(:fullname, "Fullname can't be blank.") if params[:fullname].blank?
      user.errors.add(:card_type, "Card Type can't be blank.") if params[:card_type].blank?
      user.errors.add(:card_number, "Card Number can't be blank.") if params[:card_number].blank?
      user.errors.add(:card_number, "CVC code can't be blank.") if params[:cvc].blank?
      user.errors.add(:month, "Card expiration month can't be blank.") if params[:month].blank?
      user.errors.add(:year, "Card expiration year can't be blank.") if params[:year].blank?
      user.errors.add(:billing_address_1, "Billing Address can't be blank.") if params[:billing_address_1].blank?
      #user.errors.add(:billing_address_2, "Card expiration month can't be blank") if params[:billing_address_2].blank?
      user.errors.add(:city, "City can't be blank.") if params[:city].blank?
      user.errors.add(:state, "State can't be blank.") if params[:state].blank?
      user.errors.add(:zip, "Zip can't be blank.") if params[:zip].blank?
      
       #Expiration date greater than today
      today = Date.today
      if (params[:year].to_i < today.year || (params[:year].to_i == today.year && params[:month].to_i <= today.month))
        user.errors.add(:expiration_date, "invalid expiration date.")
      end  
      

      if user.errors.length > 0
        session[:errors] = user.errors
        redirect_to admin_signup_step3_path
      else
        session[:errors] = nil
      end
    end
  end
  
  def first_payment(card_number, month, year, cvc, card_type, user)
    transaction = AuthorizeNet::AIM::Transaction.new("65Bu23LnR5cZ", "74Je52vFgb6L8w66", :gateway => :production, :test => AUTHORIZE_NET_TEST_MODE)
    credit_card = AuthorizeNet::CreditCard.new(card_number, month + year, {:card_code=> cvc, :card_type => card_type})
    #add billing information
    transaction.set_fields({:first_name => user.first_name,
                            :last_name => user.last_name,
                            :address => (params[:billing_address_1] + ", " + params[:billing_address_2]) , 
                            :city => params[:city],
                            :state => State.find_by_id(params[:state]).name,
                            :zip => params[:zip],
                            :email => user.email})
    
    response = transaction.purchase(user.subscription.cost.round(2).to_s, credit_card)
    puts "Successfully made a purchase (authorization code: #{response.authorization_code})"
    return response
  end
  
  #recurring billing
  def create_autorrecuring_subscription(start_date, user, card_number, month, year, cvc, card_type, city, state, billing_address_1, billing_address_2)
    credit_card = AuthorizeNet::CreditCard.new(card_number, month + year, {:card_code=> cvc, :card_type => card_type})
    arb_transaction = AuthorizeNet::ARB::Transaction.new("65Bu23LnR5cZ", "74Je52vFgb6L8w66", :gateway => :production, :test => AUTHORIZE_NET_TEST_MODE)
    subscription = AuthorizeNet::ARB::Subscription.new(
                          :name => "Hostess Restaurant Listing",
                          :length => 1,
                          :unit => "months",
                          :start_date => start_date, #Date.today.at_beginning_of_month.next_month
                          :total_occurrences => 9999,
                          :amount => user.subscription.cost.round(2).to_s,
                          :description => "Provides listing in the Hostess application database for one month, including restaurant information and specials.",
                          :credit_card => credit_card,
                          :customer => AuthorizeNet::Customer.new(:email => user.email, :ip => request.remote_ip),
                          :billing_address => AuthorizeNet::Address.new(:first_name => user.first_name,
                                                                        :last_name => user.last_name,
                                                                        :city => city,
                                                                        :state => State.find_by_id(state).name,
                                                                        :zip => user.zip,
                                                                        :street_address => billing_address_1 + ", " + billing_address_2))
      response = arb_transaction.create(subscription)
  end
end
