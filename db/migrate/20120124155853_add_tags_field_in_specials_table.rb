class AddTagsFieldInSpecialsTable < ActiveRecord::Migration
  def self.up
    add_column :specials, :tags, :string
  end

  def self.down
    remove_column :specials, :tags
  end
end
