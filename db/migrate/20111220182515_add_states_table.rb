class AddStatesTable < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.integer :numeric_code
      t.string :alpha_code, :limit=>5
      t.string :name, :limit=>30
    end
    add_index :states, :alpha_code
  end

  def self.down
    drop_table :states
  end
  
end