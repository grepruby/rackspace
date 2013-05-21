class Restaurant < ActiveRecord::Base
  
  HOSTESSMESSAGE = "As a restaurant owner, you are always looking for ways to promote your offerings and attract new guests while keeping 
  current guests engaged. Hostess allows your restaurant to be found quickly, menu views, ad displays, and instant access 
  to your phone number for take-out orders and reservations. Hostess gives restaurants the ability to initiate and control 
  marketing campaigns in real time directly to those interested. You decide what and when to promote. Better manage food costs, 
  table down times, holidays, in-store events, and special events."
  
  belongs_to :state
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :specials, :dependent => :destroy
  has_attached_file :photo,
                    :default_style => :small,
                    :styles => { :small => '78x78#', :big => '600x600#' },
                    :url => "/system/:attachment/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
                    :dependent => :delete
                    
  has_and_belongs_to_many :app_tokens, :delete_sql => 'DELETE FROM app_tokens_restaurants WHERE restaurant_id=#{id}'
  has_and_belongs_to_many :food_categories, :delete_sql => 'DELETE FROM food_categories_restaurants WHERE restaurant_id=#{id}'
  
  geocoded_by :full_street_address
  after_validation :geocode
  
  #scope :search_includes, :joins=>[:specials, :food_categories]
  scope :search_includes, :group => 'restaurants.id', :joins=>["left join specials on specials.restaurant_id = restaurants.id left join food_categories_restaurants on food_categories_restaurants.restaurant_id = restaurants.id left join food_categories on food_categories_restaurants.food_category_id = food_categories.id"]
  
  scope :search, lambda { |query_text|
                          # TODO temporal solution, we may need to refactor this later
                          # tries to generate both the string for the query and the required parameters 
                          temp_query = []
                          query_elements = {}
                          query_text.length.times do |i|
                            if(query_text[i].size > 3) 
                              temp_query << "(restaurants.name LIKE :query_text_#{i} OR food_categories.name LIKE :query_text_#{i} OR specials.tags LIKE :query_text_#{i} OR specials.title LIKE :query_text_#{i})"
                              query_elements["query_text_#{i}".to_sym] = query_text[i]
                            end
                          end
                          where(temp_query.join(' OR '), query_elements)}

  scope :favorites_by_udid, lambda { |uuid| where(['udid = ? ', uuid])}
  scope :active, lambda { where("users.arb_status = ?", AuthorizeNet::ARB::Subscription::Status::ACTIVE) }
  # remove the user in root for json
  ActiveRecord::Base.include_root_in_json = false
  attr_accessor :favorite
  
  def self.search_elements(latitude, longitude, distance, query, udid)
    # Load all the restaurants that are near the parameters, if no parameters has being supplied display 
    # all the restaurant.
    restaurants = Restaurant.joins('left join users on users.id = restaurants.user_id').active.near([latitude,longitude], distance.to_i, :order=>:distance)
    # in the case where the user typed a valid query value
    if query
      query_text = query
      # add the percentage to the elements
      full_query_text = "%#{query_text}%"
      # include the "include" section
      restaurants = restaurants.search_includes
      # Split the words by special characters
      query_text = query_text.split(/\W+/).collect{|t| "%#{t}%"}
      #if the list already have the element do not add it
      query_text << full_query_text if !query_text.include?(full_query_text)
      # execute the search. Now is not displaying as good results as posible.
      restaurants = restaurants.search(query_text)
    end
    
    # method that mark the restaurants as favorites
    self.mark_favorites(udid, restaurants)
    
    #Now load the information from Google Places
    client = GooglePlaces::Client.new(GOOGLE_API_KEY)
    # distance is always on miles, so we need to change it to meters
    distance = (distance.to_i / 1.60934) * 1000
    # Always load the first 20 elements in a range according with the settings received from the device
    #places = client.spots(latitude, longitude, :types => ['restaurant', 'food', 'cafe'], :radius=>distance.to_i, :name=>query)
    places = client.spots(latitude, longitude, :types => ['restaurant', 'cafe'], :rankby=>'distance', :name=>query)
    # load the app token just once
    app_token = AppToken.find_by_udid(udid)
    restaurants.all.each do |r|
      # always add a record on the analytics for this restaurant
      Analytic.create(:tracker_id => r.id,:app_token_id => app_token.id, :tracker_type => Analytic::TRACKER_TYPE_RESTAURANT, :event_type => Analytic::LOCATION_HIT_EVENT)
    end
    # merge places and restaurants in one list
    restaurants = merge_places(restaurants.all, places, latitude, longitude)
    # return the final list after the merge
    restaurants
  end

  def state_name
    self.state.to_s
  end
  
  def owner_name
    self.owner.try(:name).to_s
  end
  
  def food_category_name
    self.food_categories.join(', ')
  end
  
  # method that will generate the address for generating the latitude and the longitude
  def full_street_address
    "#{self.address}, #{self.city}, #{self.state.try(:alpha_code)} #{self.zipcode} US"
  end
  
  def photo_url
     self.photo.url(:small) #if self.photo.file?
  end
  
  def photo_url_small
    return "" if self.photo.nil?
    return self.photo.url(:small)
  end
  
  def photo_big_url
    return self.photo.url(:big)
  end
  
  # retrieve the number of specials
  def total_specials
    self.specials.displayable(Date.today).count
  end
  
  def self.mark_favorites(udid, restaurants)
    all_fav_restaurants = Restaurant.joins(:app_tokens).favorites_by_udid(udid).all if udid && !udid.blank?
    # force the query
    restaurants.each do |r|
      selected = []
      selected = all_fav_restaurants.select{|fav| fav.id == r.id} if(all_fav_restaurants)
      r.favorite = selected.size > 0 ? true : false 
    end
  end
  
  def status
    arb_transaction = AuthorizeNet::ARB::Transaction.new("65Bu23LnR5cZ", "74Je52vFgb6L8w66", :gateway => :production, :test => true)
    response = arb_transaction.get_status(self.owner.arb_subscription_id)
    return response.subscription_status
  end
  
  def active?
    self.owner.try(:arb_status) && self.owner.try(:arb_status) == AuthorizeNet::ARB::Subscription::Status::ACTIVE
  end
  
  def to_h
    {:state_name=>state_name, :owner_name=>owner_name, :food_category_name=>food_category_name, :photo_url=>photo_url,
      :photo_big_url=>photo_big_url, :total_specials=>total_specials, :favorite=>favorite, :address=>self.address,
      :city=>self.city, :name=>self.name, :latitude=>self.latitude, :longitude=>self.longitude, :cost=>self.cost,
      :video_url=>self.video_url, :zipcode=>self.zipcode, :id=>self.id, :phone_number=>self.phone_number, 
      :favorite=>self.favorite, :website=>self.website, :distance=>self.distance, :menu_url=>self.menu_url, :from_hostess=>true }
  end
  
  # Json override
  def as_json(options={})
    super(options.merge(:methods => [:state_name, :owner_name, :food_category_name, :photo_url,:photo_big_url, :total_specials, :favorite], :except=>[:bearing, :state_id, :food_category_id, :photo_file_name, :photo_updated_at, :photo_content_type,:photo_file_size, :user_id, :created_at, :updated_at]))
  end
  
  # ------ PLACES METHODS
  def self.place_to_h(place, current_location)
    {:name=>place.name, :latitude=>place.lat, :longitude=>place.lng,
     :phone_number=>place.international_phone_number, :favorite=>false, :website=>place.website, 
     :distance=>Geocoder::Calculations.distance_between(current_location, [place.lat, place.lng]), 
     :from_hostess=>false}
  end
  
  # method that merge restaurants with Places
  def self.merge_places(restaurants, places, latitude, longitude)
    merged_list = []
    # We need to remove the places that are in the same position of the restaurants in our database
    restaurants.each do |r|
      # remove the repeated places
      places.delete_if{|p| Geocoder::Calculations.distance_between([r.latitude, r.longitude], [p.lat, p.lng]) < MAX_EQUAL_PROXIMITY_RANGE }
      if r.distance.to_f <= 2
        merged_list << r.to_h
      end
    end
    # google places do not sort the restaurants by distance, so we can concatenate both arrays and then sort
    merged_list += (restaurants+places).collect{|p| p.is_a?(Restaurant) ? p.to_h : place_to_h(p, [latitude, longitude])}.sort{|a,b| a[:distance].to_f <=> b[:distance].to_f}
    # remove repeats (as we may have the restaurants twice), then use only the first 20
    merged_list.uniq[0..30]
  end
  
end
