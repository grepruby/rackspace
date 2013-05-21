class AddSubscriptionTable < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :name
      t.decimal :cost, :precision => 6, :scale => 2
      t.timestamps
    end
    
    change_table :users do |u|
      u.references :subscription
    end

    
  end

  def self.down
    drop_table :subscriptions
    rename_column :users, :subscription_id
  end
end