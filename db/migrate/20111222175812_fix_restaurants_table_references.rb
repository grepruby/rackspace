class FixRestaurantsTableReferences < ActiveRecord::Migration
  def self.up
    remove_column :restaurants, :states_id
    remove_column :restaurants, :food_categories_id
    remove_column :restaurants, :users_id
    
    change_table :restaurants do |r|
      r.references :state
      r.references :food_category
      r.references :user
    end
  end

  def self.down
    remove_column :restaurants, :state_id
    remove_column :restaurants, :food_category_id
    remove_column :restaurants, :user_id
    
    change_table :restaurants do |r|
      r.references :states
      r.references :food_categories
      r.references :users
    end
  end
  
end