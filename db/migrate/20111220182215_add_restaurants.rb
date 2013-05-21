class AddRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.string :name, :limit=>100
      t.string :website, :limit=>200
      t.string :phone_number, :limit=>18
      t.string :address
      t.string :city, :limit=>50
      t.decimal :cost, :precision => 6, :scale => 2
      t.string :zipcode, :limit=>10
      t.timestamps
    end
    
    change_table :restaurants do |r|
      r.references :states
      r.references :food_categories
      r.references :users
    end
  end

  def self.down
    drop_table :restaurants
  end
  
end