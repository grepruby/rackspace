class AddConfirmColWithUser < ActiveRecord::Migration
  def self.up
    add_column :users, :confirm, :boolean, :default => false
  end

  def self.down
    remove_column :users, :confirm
  end
end