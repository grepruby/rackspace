class FoodCategory < ActiveRecord::Base
  has_and_belongs_to_many :restaurants
    
  # remove the user in root for json
  ActiveRecord::Base.include_root_in_json = false
  
  # defines the override for the method that prints the Food Category
  def to_s
    self.name
  end
end
