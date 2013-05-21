class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :mailer_set_url_options

  def after_sign_in_path_for(resource_or_scope)
    session[:specials] = nil
    unless current_user.arb_subscription_id.nil?
      arb_transaction = AuthorizeNet::ARB::Transaction.new("65Bu23LnR5cZ", "74Je52vFgb6L8w66", :gateway => :production, :test => false)
      response = arb_transaction.get_status(current_user.arb_subscription_id)
      if current_user.arb_status.nil? || current_user.arb_status != response.subscription_status
        current_user.arb_status = response.subscription_status
        current_user.save
      end
    end
    super
  end

  
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  
  def index
      
  end
  
  protected
  
  # A method that renders a Record Not Found error message.
  # This method can be used for rescue_from in all the services  
  def record_not_found
    render :json => {:success=>false, :error_code => 404, :error_msg=>"Record not Found"}
  end 
  
  # A method that renders a Bad Request error message.
  def bad_request
    render :json => {:success=>false, :error_code=> 400, :error_msg=>"Bad Request"}
  end
  
  # A method that renders a Bad Request error message if the id parameter is not valid.
  def validate_id_parameter
    bad_request if(params[:id].nil? || (/^\d+$/ =~ params[:id]).nil?)
  end
  
end
