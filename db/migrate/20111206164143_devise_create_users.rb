class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :zip

      #t.references :user_status
      #t.references :user_role
      #t.references :subscription

      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
