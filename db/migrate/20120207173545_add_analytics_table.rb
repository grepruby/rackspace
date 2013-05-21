class AddAnalyticsTable < ActiveRecord::Migration
  def self.up
     create_table :analytics do |t|
       t.references :tracker
       t.references :app_token
       t.string :tracker_type, :limit=>45
       t.integer :event_type
       t.timestamps
    end
  end

  def self.down
    drop_table :analytics
  end
end
