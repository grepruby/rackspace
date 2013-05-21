class Services::FoodCategoriesController < ApplicationController
  
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  # GET /services/food_categories
  def index
    food_categories = FoodCategory.all
    render :json => {:success=>true, :food_categories=>food_categories}
  end

end