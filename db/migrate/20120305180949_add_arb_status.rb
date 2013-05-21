class AddArbStatus < ActiveRecord::Migration
  def self.up
    add_column :users, :arb_status, :string
  end

  def self.down
    remove_column :users, :arb_status
  end
end
