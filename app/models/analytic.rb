class Analytic < ActiveRecord::Base
  
  belongs_to :tracker, :polymorphic => true
  
  TRACKER_TYPE_SPECIAL = 'Special'
  TRACKER_TYPE_RESTAURANT = 'Restaurant'
  
  LOCATION_HIT_EVENT = 0
  RESTAURANT_VISITED_EVENT = 1
  ADD_FAVORITE_RESTAURANT_EVENT = 2
  ADD_FAVORITE_SPECIAL_EVENT = 3
  REDEEM_SPECIAL_EVENT = 4

  scope :times_displayed_in_search, lambda {|id|{
    :select => "count(id) as total,  DATE_FORMAT(created_at, '%M %Y') as month",
    :conditions => "tracker_id=#{id} and tracker_type='Restaurant' and event_type=0",
    :group => "YEAR(created_at), MONTH(created_at)"}}
  scope :restaurant_page_views, lambda {|id|{
    :select => "count(id) as total,  DATE_FORMAT(created_at, '%M %Y') as month",
    :conditions => "tracker_id=#{id} and tracker_type='Restaurant' and event_type=1",
    :group => "YEAR(created_at), MONTH(created_at)"}}
  scope :times_added_resturant_in_favorite, lambda {|id|{
    :select => "count(id) as total,  DATE_FORMAT(created_at, '%M %Y') as month",
    :conditions => "tracker_id=#{id} and tracker_type='Restaurant' and event_type=2",
    :group => "YEAR(created_at), MONTH(created_at)"}}
  scope :times_added_special_in_favorite, lambda {|id|{
    :select => "count(id) as total,  DATE_FORMAT(created_at, '%M %Y') as month",
    :conditions => "tracker_id in (select specials.id from specials where specials.restaurant_id=#{id}) and tracker_type='Special' and event_type=3",
    :group => "YEAR(created_at), MONTH(created_at)"}}
  scope :number_of_redemptions, lambda {|id|{
    :select => "count(id) as total,  DATE_FORMAT(created_at, '%M %Y') as month",
    :conditions => "tracker_id in (select specials.id from specials where specials.restaurant_id=#{id}) and tracker_type='Special' and event_type=4",
    :group => "YEAR(created_at), MONTH(created_at)"}}
end