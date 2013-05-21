class AddFavoriteRestaurantsSpecials < ActiveRecord::Migration
  def self.up
    create_table :app_tokens_specials, {:id => false} do |r|
      r.references :app_token
      r.references :special
    end
    add_index(:app_tokens_specials, [:app_token_id, :special_id], :unique => true, :name => 'by_app_token_specials')
    
  end

  def self.down
    drop_table :app_tokens_specials
  end
end