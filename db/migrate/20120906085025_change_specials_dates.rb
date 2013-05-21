class ChangeSpecialsDates < ActiveRecord::Migration
  def self.up
    change_column :specials, :start_date, :date
    change_column :specials, :end_date, :date
  end

  def self.down
    change_column :specials, :start_date, :datetime
    change_column :specials, :end_date, :datetime
  end
end
