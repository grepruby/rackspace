class AdminController < ApplicationController
  layout 'application'

  before_filter :is_user_authenticate
  before_filter :load_restaurant, :only => [:design, :refresh_design, :my_info, :specials, :refresh_special, :analytics ]

  #home page for user
  def design
    
  end
  
  # method called in ajax funtion for the my restaurant info
  def my_info
  end
  
  # method called when the restaurant info need to be refresh on the iphone section
  def refresh_design
      
    @restaurant.name = params[:restaurant_name] unless params[:restaurant_name].blank?
    @restaurant.website = params[:website_url] unless params[:website_url].blank?
    @restaurant.menu_url = params[:menu_url] unless params[:menu_url].blank?
    @restaurant.video_url = params[:video_url]
    @restaurant.phone_number = params[:restaurant_phone_number] unless params[:restaurant_phone_number].blank?
    @restaurant.address = params[:restaurant_address] unless params[:restaurant_address].blank?
    @restaurant.city = params[:city] unless params[:city].blank?
    @restaurant.state_id = params[:state] unless params[:state].blank?
    @restaurant.zipcode = params[:zip] unless params[:zip].blank?
    @restaurant.food_categories = FoodCategory.find(params[:food_categories]) unless params[:food_categories].nil?
    
    if (!params[:upload].blank?)
      @restaurant.photo = params[:upload]  
    end    
    
    if (!@restaurant.photo.blank?)
      @tempfile = TempPaperclipFile.create(:photo => @restaurant.photo)      
    end
    
    if params[:to_save] and params[:to_save] == "true"      
      @restaurant.save
    end
  end

  
  # method called in ajax funtion for the specials list
  def specials
    return unless session[:specials].nil?
    if @restaurant.specials.nil? or @restaurant.specials.length == 0 
      session[:specials] = Array.new
      session[:specials] <<  Special.new()
    else
      session[:specials] = Array.new
      @restaurant.specials.each do |s|
        st = Special.new(:id => s.id, :title => s.title, :deal_details => s.deal_details, :start_date => s.start_date, :end_date => s.end_date, :restaurant_id => s.restaurant_id, :tags => s.tags, :photo_file_name => s.photo_file_name, :photo => nil)
        st.id = s.id 
        session[:specials] << st
      end
      #session[:specials] = @restaurant.specials.to_a 
    end
  end
  
  # method called when the special info need to be refresh on the iphone section
  def refresh_special
    @selected = ''
    #The delete action is fired from a different form
    if (params[:deleteFormAction] == 'deleteSpecial')
      action = 'deleteSpecial'
    else
      action = params[:formAction]  
    end    
    
    if action == "addSpecial"
      session[:specials] << Special.new()
      params[:specialSelected] = session[:specials].length.to_i - 1
    elsif action == "deleteSpecial"
      index = params[:specialSelectedOnDelete].to_i
      params[:specialSelectedOnDelete] = index - 1 if index != 0      
      special = session[:specials][index]
      unless special.id.nil?
        @restaurant.specials.delete(special)
        Special.delete(special.id)
      end
      session[:specials].delete_at(index)
    elsif action == "previewSpecial"
      index = params[:specialSelected].to_i
      set_special_on_array(index,params[:special_title],params[:special_details],params[:special_start_date],params[:special_end_date],params[:special_tags].gsub(/\r\n/,','),nil,session[:specials][index].photo_file_name)
    elsif action == "saveSpecial"
      index = params[:specialSelected].to_i
      special = session[:specials][index]
     
      if special.id.nil?
        @show_notifications_confirmation = false
        temp = Special.new
      else
        @show_notifications_confirmation = true
        temp = Special.find_by_id(special.id)
      end
      temp.title = params[:special_title]
      temp.deal_details = params[:special_details]
      temp.start_date = Date.strptime(params[:special_start_date],"%m/%d/%Y") unless params[:special_start_date].blank? 
      temp.end_date = Date.strptime(params[:special_end_date],"%m/%d/%Y") unless params[:special_end_date].blank?
      temp.restaurant_id = @restaurant.id
      temp.tags = params[:special_tags].gsub(/\r\n/,',')
      temp.send_update = false
      if (!params[:special_photo].blank?)
        temp.photo = params[:special_photo]
      end 
      temp.save
      puts temp.errors.inspect
      special.id = temp.id
      set_special_on_array(index,params[:special_title],params[:special_details],params[:special_start_date],params[:special_end_date],params[:special_tags].gsub(/\r\n/,','),temp.restaurant_id, temp.photo_file_name)
    elsif action == "sendUpdateNotifications"
      index = params[:specialSelected].to_i
      special = session[:specials][index]
      special.send_update = true
      special.send_updated_notification()
    elsif action.blank?
      params[:formAction] = "no_action"
    else
      @selected = "special" + action.to_s
      params[:specialSelected] = action.to_i
      params[:formAction] = action.to_i
    end
    
    
  end

  # anlitycs page
  def analytics
    @searchs = Analytic.times_displayed_in_search(@restaurant.id)
    @page_views = Analytic.restaurant_page_views(@restaurant.id)
    @resturant_in_favorite = Analytic.times_added_resturant_in_favorite(@restaurant.id)
    @specials_in_favorite = Analytic.times_added_special_in_favorite(@restaurant.id)
    @redemptions = Analytic.number_of_redemptions(@restaurant.id)
  end

  private

  #validate is a user log in
  def is_user_authenticate
    redirect_to '/users/sign_in' if current_user.nil?
  end
  
  #load restaurant info
  def load_restaurant
    @restaurant = Restaurant.find_by_user_id(current_user.id)
    if @restaurant.nil?
      @restaurant = Restaurant.new
      @restaurant.user_id = current_user.id
      @restaurant.save
    end
    
  end
  
  #set set_special_on_array
  def set_special_on_array(index, title, deal_details, start_date, end_date, tags,restaurant_id, photo_file_name)
    session[:specials][index].title = title
    session[:specials][index].deal_details = deal_details
    session[:specials][index].start_date = Date.strptime(start_date,"%m/%d/%Y") unless start_date.blank?
    session[:specials][index].end_date = Date.strptime(end_date,"%m/%d/%Y") unless end_date.blank?
    session[:specials][index].tags = tags
    session[:specials][index].restaurant_id = restaurant_id
    session[:specials][index].photo_file_name = photo_file_name
  end
end
