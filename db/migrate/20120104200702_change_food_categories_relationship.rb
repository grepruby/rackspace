class ChangeFoodCategoriesRelationship < ActiveRecord::Migration
  def self.up
    create_table :food_categories_restaurants, {:id => false} do |t|
      t.references :food_category
      t.references :restaurant
      t.timestamps
    end
    remove_column :restaurants, :food_category_id
    add_index(:food_categories_restaurants, [:food_category_id, :restaurant_id], :unique => true, :name => 'by_food_categories_restaurants')
  end

  def self.down
    drop_table :food_categories_restaurants
  end
end
