class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, ,  and :omniauthable, :validatable, :registerable, :lockable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :timeoutable, :validatable

  #relations
  belongs_to :subscription
  belongs_to :billing_information, :dependent => :destroy
  
  after_destroy :delete_relationships
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :last_name, :first_name, :email, :email_confirmation, :password, :password_confirmation, :remember_me
  
  #validators
  validates :first_name, :presence => true, :on => :new
  validates :last_name, :presence => true , :on => :new
  validates_confirmation_of :email
  
  def name
    "#{first_name} #{last_name}"
  end
  # remove the user in root for jason
  ActiveRecord::Base.include_root_in_json = false
  
  def add_billing_information(full_name, billing_address_1, billing_address_2, city, state_id, zip)
    billing_info = BillingInformation.create(:user_id => self.id, :full_name => full_name, :billing_address_1 => billing_address_1, 
                              :billing_address_2 => billing_address_2, :city => city, :state_id => state_id, :zip => zip)
    return billing_info
  end
  
  def delete_relationships
    restaurant = Restaurant.find_by_user_id(self.id)
    restaurant.destroy()
    
    #remove ARB sbuscription
    arb_transaction = AuthorizeNet::ARB::Transaction.new("65Bu23LnR5cZ", "74Je52vFgb6L8w66", :gateway => :production, :test => true)
    response = arb_transaction.cancel(self.arb_subscription_id) unless arb_subscription_id.nil? 
  end
  
  #validate arb status
  def self.update_arb_status
    users = User.find(:all)
    users.each do |u|
      unless u.arb_subscription_id.nil?
         arb_transaction = AuthorizeNet::ARB::Transaction.new("65Bu23LnR5cZ", "74Je52vFgb6L8w66", :gateway => :production, :test => false)
         response = arb_transaction.get_status(u.arb_subscription_id)
         if u.arb_status.nil? || u.arb_status != response.subscription_status
            puts response.subscription_status
            Rails.logger.info(Time.new.inspect + ": User ARB Status updated (user_id=" + u.id.to_s + ", old_status=" + u.arb_status.to_s + ", new_status=" + response.subscription_status + ")")
            u.arb_status = response.subscription_status
            u.save
         end
         
      end        
    end
  end
  
  # deliver a welcome email right after creating the record
  def after_create
    Notifier.welcome_message(self).deliver
  end
end
