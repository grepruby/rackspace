class Services::RestaurantsController < ApplicationController
  before_filter :validate_id_parameter, :only=>[:show]
  before_filter :generate_coordinates_from_params, :only => [:all_near_position]
  before_filter :validate_pagination_params, :only=>[:index, :all_near_position]
  before_filter :validate_search_params, :only=>[:all_near_position]
  before_filter :validate_udid, :only=>[:show, :favorites, :add_to_favorites, :remove_from_favorites]
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  # GET /services/restaurants
  def index
    restaurants = Restaurant.paginate(:page => params[:page].to_i, :per_page => params[:per_page].to_i)
    render :json => {:success=>true, :restaurants=>restaurants, :total_elements=>restaurants.total_entries}
  end
  
  # Method that returns the list of restaurants that are near an specific position
  def all_near_position
    params[:dist] ||= 50
    # check if the latitude and longitude are valid
    if @latitude.nil? || @longitude.nil?
      restaurants = []
      total_restaurants = 0
    else
      restaurants = Restaurant.search_elements(@latitude, @longitude, params[:dist], params[:q], params[:udid])
      total_restaurants = restaurants.size
    end
    render :json => {:success=>true, :restaurants=>restaurants, :total_elements=>total_restaurants}
  end

  # GET /services/restaurants/:id 
  def show
    restaurant = Restaurant.find(params[:id])
    restaurant.favorite = false
    restaurant.app_tokens.each do |a|
       restaurant.favorite = true if @app_token.id == a.id
    end
    
    # always render a json
    render :json => {:success=>true, :restaurant=>restaurant}
  end
  
  # GET /services/favorites/:udid
  def favorites
    restaurants = @app_token.restaurants.joins('left join users on users.id = restaurants.user_id').active
    restaurants.each { |r| r.favorite = true }
    render :json => {:success=>true, :favorites=> restaurants}
  end
  
  # POST /services/favorites/:udid/:id
  def add_to_favorites
    restaurant = Restaurant.find(params[:restaurant_id])
    @app_token.restaurants << restaurant unless @app_token.restaurants.find_by_id(restaurant.id)
    #add analytic event
    Analytic.create(:tracker_id => restaurant.id, :app_token_id => @app_token.id, :tracker_type => Analytic::TRACKER_TYPE_RESTAURANT, :event_type => Analytic::ADD_FAVORITE_RESTAURANT_EVENT)
    render :json => {:success=>true}
  end  
  
  # DELETE /services/favorites/:udid/:id
  def remove_from_favorites
    restaurant = Restaurant.find(params[:restaurant_id])
    @app_token.restaurants.delete(restaurant)
    render :json => {:success=>true}
  end
  
  private
  
  def validate_udid
    @app_token = AppToken.find_by_udid(params[:udid])
    bad_request if @app_token.nil?
  end
  
  def generate_coordinates_from_params
    # if the user supplies the [:loc] value in the params, load the information of this specific point and ignore the coordinates 
    if(params[:loc] && !params[:loc].blank?)
      # Find the location by using geocoder. Just in case, always include "US" at the end of the request to Geocoder
      positions = Geocoder.search("#{params[:loc]} US")
      # Log the process that search for the locations by Using Geocoder API, 
      # this may allow checking the situation if something do not work as good as expected  
      Rails.logger.info "------ Searching for the location '#{params[:loc]}', the coordinates are:"
      # check if the supplied position is valid in the US, otherwise leave it nil
      if positions && positions.size > 0
        # set the values retrieved from the external server
        @longitude = positions[0].geometry['location']['lng']
        @latitude = positions[0].geometry['location']['lat']
        Rails.logger.info "------ #{@latitude}, #{@longitude}"
      end
    else
      # First split the position
      coordinates = params[:position].split(',')
      # then validate the values (the position value will always be right since the routes forced this value)
      begin
        # try to convert the param to the right float value, an Exception will be throw if the argument is not a Float.
        @latitude = Float(coordinates[0])
        @longitude = Float(coordinates[1])
      rescue ArgumentError => e
        bad_request
      end
    end
  end
  
  def validate_pagination_params
    # set the default values
    params[:per_page] ||= 10
    params[:page] ||= 1
    begin
      # try to convert the param to the right float value, an Exception will be throw if the argument is not a Float.
      @page = Integer(params[:page]) if params[:page]
      @per_page = Integer(params[:per_page]) if params[:per_page]
      @dist = Integer(params[:dist]) if params[:dist]
    rescue ArgumentError => e
      Rails.logger.error(e.message)
      bad_request
    end
  end
  
  def validate_search_params
    # at least one of the parameters should be there
    # if the params is invalid, do not do anything
    if params[:q] && params[:q].blank?
      bad_request
    end
    #check that the udid param has the right format
    if(params[:udid] && (params[:udid].blank? || !params[:udid].match(/^\w{2,128}$/)))
      bad_request
    end
  end
  
end