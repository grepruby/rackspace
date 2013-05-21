class Special < ActiveRecord::Base
  # TODO: Remove this line!!!
  #ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER#Logger.new(STDOUT)
  require 'apn'
  #has_and_belongs_to_many :users
  belongs_to :restaurant
  has_and_belongs_to_many :app_tokens, :delete_sql => 'DELETE FROM app_tokens_specials WHERE special_id=#{id}'
  
  has_attached_file :photo,
                    :default_style => :small,
                    :styles => { :small => '78x78#', :big => '600x600#' },
                    :url => "/system/specials/:attachment/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/specials/:attachment/:id/:style/:basename.:extension",
                    :dependent => :delete
  
  after_create :send_new_notification
  after_update :send_updated_notification
  attr_accessor :send_update
  attr_accessor :favorite
  
  scope :favorites_by_udid, lambda { |uuid| where(['udid = ? ', uuid])}
  scope :active, :joins=>["inner join restaurants on restaurants.id = specials.restaurant_id inner join users on users.id = restaurants.user_id and users.arb_status='active'"]
  scope :displayable, lambda { |date| where("start_date <= ? AND end_date >= ?", date, date)}
  
  # remove the user in root for json
  ActiveRecord::Base.include_root_in_json = false
  
  # Method that formats the start date of the special.
  # Initially we will display the information in MM-DD-YYYY
  def initial_date
    self.start_date.strftime('%m-%d-%Y')
  end
  
  # Method that formats the start date of the special.
  # Initially we will display the information in MM-DD-YYYY
  def final_date
    self.end_date.strftime('%m-%d-%Y')
  end
  
  # Method that formats the start date of the special.
  # Initially we will display the information in DD-MM-YYYY
  def label_title
    d = ""
    return d if self.title.nil?
    d = self.title.html_safe.gsub(/\"/, "\\\"")
    return d
  end
  
  def label_tags
    d = ""
    return d if self.tags.nil?
    d = self.tags.html_safe.gsub(/\"/, "\\\"")
    return d
  end
  
  # Method that formats the start date of the special.
  # Initially we will display the information in DD-MM-YYYY
  def label_start_date
    self.start_date.try(:strftime, '%m/%d/%Y')
  end
  
  # Method that formats the start date of the special.
  # Initially we will display the information in DD-MM-YYYY
  def label_end_date
    self.end_date.try(:strftime, '%m/%d/%Y')
  end
  
  def restaurant_name
    self.restaurant.try(:name)
  end
  
  def latitude
    self.restaurant.try(:latitude)
  end
  
  def longitude
    self.restaurant.try(:longitude)
  end
  
  def photo_url
    self.photo.url(:big) #if self.photo.file?
  end
  
  def details_n
    d = ""
    return d if deal_details.nil?
    d = self.deal_details.gsub(/\r\n/,'\n')
    d = d.html_safe.gsub(/\"/, "\\\"")
    return d.html_safe
  end
  
  def details_formatted
    d = ""
    return d if deal_details.nil?
    d = self.deal_details.gsub(/\r\n/,'<br>')
    d = d.html_safe.gsub(/\"/, "\\\"")
    return d.html_safe
  end
  
  def tags_without_n
    d = ""
    return d if deal_details.nil?
    d = self.tags.gsub(/\r\n/,',')
    d = d.html_safe.gsub(/\"/, "\\\"")
    return d.html_safe
  end
  
  # Json override
  def as_json(options={})
    super(options.merge(:methods => [:initial_date, :final_date, :photo_url, :favorite, :restaurant_name, :longitude, :latitude], :except=>[:restaurant_id, :start_date, :end_date, :created_at, :updated_at]))
  end
  
  def send_new_notification
    list = AppToken.new_notifications(self.id)
    list.each do |n|
      APN.notify(n.notifications, :alert => self.restaurant.name + " has a new specials for you.", 
                                  :sound => true, :specialId => self.id, :restaurantid => self.restaurant.id )
      Rails.logger.info(Time.new.inspect + ": New special notification(special_id=" + self.id.to_s + ", app_token_id=" + n.id.to_s + ")")
    end
  end
  
  def send_updated_notification
    return unless self.send_update
    list = AppToken.updated_notifications(self.id)
    list.each do |n|
      APN.notify(n.notifications.to_s, :alert => "One of your specials of " + self.restaurant.name + " has been updated.", 
                                       :sound => true, :specialId => self.id, :restaurantid => self.restaurant.id)
      Rails.logger.info(Time.new.inspect + ": Special update notification(special_id=" + self.id.to_s + ", app_token_id=" + n.id.to_s + ")")
    end
  end
  
  def self.send_expire_notification
    specials = Special.find_by_sql("select id,title,deal_details,start_date,end_date,position,created_at,updated_at,restaurant_id,tags from specials where DATEDIFF(end_date, curdate())=1")
    puts "#{Time.now.inspect}: Expired Specials --> #{specials.inspect}"
    specials.each do |s|
      list = AppToken.expire_notifications(s.id)
      puts "AppTokens= " + list.inspect
      list.each do |n|
        APN.notify(n.notifications, :alert => "One of your specials of " + s.restaurant.name + " is about to expire. Redeem it before it's too late.", 
                                    :sound => true, :specialId => s.id, :restaurantid => s.restaurant.id)
        Rails.logger.info(Time.new.inspect + ": Special to expire(special_id=" + s.id.to_s + ", app_token_id=" + n.id.to_s + ")")
      end
    end
  end
  
  def self.mark_favorites(udid, specials)
    all_fav_specials = Special.joins(:app_tokens).favorites_by_udid(udid).all if udid && !udid.blank?
    # force the query
    specials.each do |r|
      selected = []
      selected = all_fav_specials.select{|fav| fav.id == r.id} if(all_fav_specials)
      r.favorite = selected.size > 0 ? true : false 
    end
  end
  
  
end
