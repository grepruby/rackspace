class AddSbuscriptionIdInUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :arb_subscription_id, :string
  end

  def self.down
    remove_column :users, :arb_subscription_id
  end
end