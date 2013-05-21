class AddBillingInfoTable < ActiveRecord::Migration
  def self.up
    create_table :billing_informations do |t|
      t.references :user
      t.string :full_name
      t.string :billing_address_1
      t.string :billing_address_2
      t.string :city
      t.references :state
      t.string :zip

      t.timestamps
    end
    
    change_table :users do |u|
      u.references :billing_information
    end
    
  end

  def self.down
    drop_table :billing_informations
  end
  
end
