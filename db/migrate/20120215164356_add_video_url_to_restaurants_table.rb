class AddVideoUrlToRestaurantsTable < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :video_url, :string
  end

  def self.down
    remove_column :restaurants, :video_url
  end
end
