module ApplicationHelper
  # Returns the year options information
  def years_information
    (Date.today.year).upto(Date.today.year+11).collect{|i| "<option>#{i.to_s[2,3]}</option>"}.join('').html_safe
  end
  
  # Returns the month options information for the step 3 for signup page.
  def months_information
    (1).upto(12).collect{|i| "<option>#{"%02d" % i}</option>"}.join('').html_safe
  end
  
  # Returns the month options information for the step 3 for signup page.
  def card_types_information
    ["Visa","Mastercard","American Express"].collect{|i| "<option>#{i}</option>"}.join('').html_safe
  end
end
