class Services::NotificationsController < ApplicationController
  require 'apn'
   
  before_filter :validate_parameters, :only=>[:register]
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  #APN.notify('112C0FF154506A948D9B7B03E9058635C06E9EA80A4E9AFD15D07599A4D08B2A', :alert => "este va con sonido", :sound => true  )
  # remember run rake apn:sender for the daemon
  # GET /services/notifications/register
  def register
    app_token = AppToken.find_by_udid(params[:udid].to_s)
    if app_token.nil?
      app_token = AppToken.create(:udid => params[:udid].to_s, :notifications => params[:notification_token].to_s, 
                                  :new_specials_notifications => params[:news], :updated_specials_notifications => params[:updated],
                                  :expire_specials_notifications => params[:expire])
    else
      app_token.notifications = params[:notification_token]
      app_token.new_specials_notifications = params[:news]
      app_token.updated_specials_notifications = params[:updated]
      app_token.expire_specials_notifications = params[:expire]
      app_token.save
    end
    render :json => {:success=>true, :id => app_token.id}
  end
 
  
  private 
  
  def validate_parameters
    bad_request if params[:udid].blank?
    params[:notification_token] = nil if params[:notification_token].blank? 
    params[:news] = false if params[:news].blank? 
    params[:updated] = false if params[:updated].blank? 
    params[:expire] = false if params[:expire].blank?
  end
  

end