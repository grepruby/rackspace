class RemoveFoodCategoriesRestaurantsDates < ActiveRecord::Migration
  def self.up
    remove_column :food_categories_restaurants, :created_at
    remove_column :food_categories_restaurants, :updated_at
  end

  def self.down
    add_column :food_categories_restaurants, :created_at
    add_column :food_categories_restaurants, :updated_at
  end
end
