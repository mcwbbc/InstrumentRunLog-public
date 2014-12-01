class PriceModelsController < ApplicationController
  before_filter :authenticate
  before_filter :admin
  
  def index
    if params[:show] == 'all'
      @title = 'Pricing History'
      @all = true
      @price_models = PriceModel.order("category_id")
    else
      @title = 'Current Pricing'
      @all = false
      @price_models = PriceModel.find_not_retired
    end
    @price_models
  end
  
  def new
    @price_model = PriceModel.new
  end
  
  def create
    @price_model = PriceModel.new(params[:price_model])
    
    if @price_model.save
      redirect_to price_models_path, :notice => 'Model successfuly created'
    else
      render :action => 'edit'
    end
  end
  
  def show
    @price_model = PriceModel.find(params[:id])
  end
  
  def edit
    @price_model = PriceModel.find(params[:id])
  end
  
  def update
    @price_model = PriceModel.find(params[:id])
    if @price_model.update_attributes(params[:price_model])
      redirect_to price_models_path, :notice => 'Model successufully updated'
    else
      render :action => 'edit'
    end
  end
end
