class AddSpecialsTable < ActiveRecord::Migration
  def self.up
    create_table :specials do |t|
      t.string :title, :limit=>100
      t.text :deal_details
      t.datetime :start_date
      t.datetime :end_date
      t.integer :position
      t.timestamps
    end
    
    change_table :specials do |r|
      r.references :restaurants
    end
  end

  def self.down
    drop_table :specials
  end
  
end