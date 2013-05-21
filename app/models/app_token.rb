class AppToken < ActiveRecord::Base
  
  has_and_belongs_to_many :restaurants
  has_and_belongs_to_many :specials

  
  scope :new_notifications, lambda {|id|
    where("id in (select DISTINCT app_token_id from app_tokens_restaurants where restaurant_id in (select restaurant_id from specials where id=#{id})
                  and (select arb_status from users where id=(select user_id from restaurants where id = restaurant_id)) ='active'
                  union
                  select DISTINCT app_token_id from app_tokens_specials where special_id=#{id}
                  and (select arb_status from users where id=(select user_id from restaurants where id = (select restaurant_id from specials where id=28))) = 'active')
           and new_specials_notifications = 1")
  }
    
    
  
  scope :updated_notifications, lambda {|id|
    where("id in (select DISTINCT app_token_id from app_tokens_restaurants where restaurant_id in (select restaurant_id from specials where id=#{id})
                  and (select arb_status from users where id=(select user_id from restaurants where id = restaurant_id)) ='active'
                  union
                  select DISTINCT app_token_id from app_tokens_specials where special_id=#{id}
                  and (select arb_status from users where id=(select user_id from restaurants where id = (select restaurant_id from specials where id=28))) = 'active') 
                  and updated_specials_notifications = 1")
  }
  
  
  scope :expire_notifications, lambda {|id|
    where("id in (select DISTINCT app_token_id from app_tokens_restaurants where restaurant_id in (select restaurant_id from specials where id=#{id})
                  and (select arb_status from users where id=(select user_id from restaurants where id = restaurant_id)) ='active'
                  union
                  select DISTINCT app_token_id from app_tokens_specials where special_id=#{id}
                  and (select arb_status from users where id=(select user_id from restaurants where id = (select restaurant_id from specials where id=28))) = 'active')
                  and expire_specials_notifications = 1")
  }
  
end