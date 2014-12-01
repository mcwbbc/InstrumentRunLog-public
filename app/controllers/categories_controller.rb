class CategoriesController < ApplicationController
  before_filter :authenticate
  before_filter :admin
  
  respond_to :js, :html
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      respond_with(@category) do |format|
        format.js {render 'create.js.erb'}
        #format.js{ redirect_to new_price_model_path}
        format.html { puts "save HTML"; redirect_to new_price_model_path}
      end
    else
      respond_with(@category) do |format|
        format.js { render 'fail_create.js.erb'}
        format.html { redirect_to price_models_path}
      end
    end
  end #new
  
end
