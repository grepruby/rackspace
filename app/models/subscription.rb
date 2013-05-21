class Subscription < ActiveRecord::Base
  
  # remove the user in root for jason
  ActiveRecord::Base.include_root_in_json = false
  
  def label
    "#{self.name} - #{ActionController::Base.helpers.number_to_currency(self.cost,:precision=>2)}/Month"     
  end
  
  def secondary_label
    "#{self.name} (#{ActionController::Base.helpers.number_to_currency(self.cost,:precision=>2)})"     
  end
  
end
