class FixSpecialsTableReferences < ActiveRecord::Migration
  def self.up
    remove_column :specials, :restaurants_id
    change_table :specials do |r|
      r.references :restaurant
    end
  end

  def self.down
    remove_column :specials, :restaurant_id
    change_table :specials do |r|
      r.references :restaurants
    end
  end
end