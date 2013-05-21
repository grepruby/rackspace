class AddFoodCategoryTable < ActiveRecord::Migration
  def self.up
    create_table :food_categories do |t|
      t.string :name, :limit=>50
    end
  end

  def self.down
    drop_table :food_categories
  end
  
end