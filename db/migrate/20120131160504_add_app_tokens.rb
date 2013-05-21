class AddAppTokens < ActiveRecord::Migration
  def self.up
    create_table :app_tokens do |t|
      t.string :udid, :limit=>128
      t.string :notifications, :limit=>128
      t.boolean :new_specials_notifications
      t.boolean :updated_specials_notifications
      t.boolean :expire_specials_notifications
      t.timestamps
    end
    
    create_table :app_tokens_restaurants, {:id => false} do |r|
      r.references :app_token
      r.references :restaurant
    end
    
    add_index(:app_tokens_restaurants, [:app_token_id, :restaurant_id], :unique => true, :name => 'by_app_token_restaurants')
    
  end

  def self.down
    drop_table :app_tokens
    drop_table :app_tokens_restaurants
  end
end
