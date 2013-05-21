class AddSubscriptionsRow < ActiveRecord::Migration
  def self.up
    Subscription.create(:id => 1, :name => 'Basic', :cost  => (18))
    Subscription.create(:id => 2, :name => 'Plus', :cost  => (22))
    Subscription.create(:id => 3, :name => 'Star', :cost  => (28))
  end

  def self.down
    
  end
end
