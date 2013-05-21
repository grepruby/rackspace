class AddMenuUrlRestaurantTable < ActiveRecord::Migration
  def self.up
    change_table :restaurants do |r|
      r.string :menu_url
    end
  end

  def self.down
    remove_column :restaurants, :menu_url
  end
end
