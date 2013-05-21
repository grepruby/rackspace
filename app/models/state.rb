class State < ActiveRecord::Base
  has_many :restaurants
    
  # remove the user in root for json
  ActiveRecord::Base.include_root_in_json = false
  
  # defines the override for the method that prints the State
  def to_s
    name
  end
end
