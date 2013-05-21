class Services::SpecialsController < ApplicationController
  before_filter :validate_id_parameter, :only=>[:show]
  before_filter :validate_udid, :only=>[:favorites, :add_to_favorites, :remove_from_favorites, :redeem]
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  # GET /services/specials
  def index
    specials = Special.displayable(Date.today)
    render :json => {:success=>true, :specials=>specials}
  end

  # GET /services/specials/restaurant/:id
  def list_by_restaurant
    restaurant = Restaurant.find(params[:id])
    # check if the restaurant is active, otherwise always display no specials
    if restaurant.active?
      specials = restaurant.specials.displayable(Date.today).all
      # method that mark the restaurants as favorites
      Special.mark_favorites(params[:udid], specials)
    else
      specials = []
    end
    # save analytic event
    app_token = AppToken.find_by_udid(params[:udid])
    Analytic.create(:tracker_id => restaurant.id, :app_token_id => app_token.id, :tracker_type => Analytic::TRACKER_TYPE_RESTAURANT, :event_type => Analytic::RESTAURANT_VISITED_EVENT)
    # always render a json
    render :json => {:success=>true, :specials=>specials}
  end
  
  # GET /services/specials/:id
  def show
    special = Special.find(params[:id])
    # always render a json
    render :json => {:success=>true, :special=>special}
  end
  
  # GET /services/favorites/:udid
  def favorites
    specials = @app_token.specials.active.displayable(Date.today).all
    specials.each { |s| s.favorite = true }
    render :json => {:success=>true, :favorites=> specials}
  end
  
  # POST /services/favorites/:udid/:id
  def add_to_favorites
    special = Special.find(params[:special_id])
    @app_token.specials << special unless @app_token.specials.find_by_id(special.id)
    #add analytics event
    Analytic.create(:tracker_id => special.id, :app_token_id => @app_token.id, :tracker_type => Analytic::TRACKER_TYPE_SPECIAL, :event_type => Analytic::ADD_FAVORITE_SPECIAL_EVENT)
    render :json => {:success=>true}
  end  
  
  # DELETE /services/favorites/:udid/:id
  def remove_from_favorites
    special = Special.find(params[:special_id])
    @app_token.specials.delete(special) 
    render :json => {:success=>true}
  end
  
  # GET /services/favorites/:udid/:id
  def redeem
    special = Special.find(params[:special_id])
    #add analytics event
    Analytic.create(:tracker_id => special.id, :app_token_id =>  @app_token.id, :tracker_type => Analytic::TRACKER_TYPE_SPECIAL, :event_type => Analytic::REDEEM_SPECIAL_EVENT)
    render :json => {:success=>true}
  end
  
  private
  
  def validate_udid
    @app_token = AppToken.find_by_udid(params[:udid])
    bad_request if @app_token.nil?
  end
  
end