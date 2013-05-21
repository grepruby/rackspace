class AddRestaurantsLatitudeAndLongitude < ActiveRecord::Migration
  def self.up
    change_table :restaurants do |r|
      r.float :latitude
      r.float :longitude
    end
  end

  def self.down
    remove_column :restaurants, :latitude
    remove_column :restaurants, :longitude
  end
end