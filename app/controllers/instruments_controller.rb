class InstrumentsController < ApplicationController
  before_filter :authenticate
  before_filter :admin, :except => [:show, :categories]
  
  respond_to :js, :xml, :json, :html
  
  def new
    @instrument = Instrument.new
  end
  
  def create
    @instrument = Instrument.new(params[:instrument])
    if @instrument.save
      respond_with(@instrument) do |format|
        format.html { puts "save HTML"; redirect_to new_price_model_path, :notice => 'Thanks for your comment'}
      end
    else
      respond_with(@instrument) do |format|
        format.js { render 'fail_create.js.erb'}
        format.html { redirect_to price_models_path, :alert => 'Unable to add comment' }
      end
    end
  end #new
  
  def show
    @instrument = Instrument.find(params[:id])
    
    respond_to do |format|
      format.xml { render :xml => @instrument }
    end
  end
  
  def categories
    @instrument = Instrument.find_by_name(params[:name])
    
    respond_to do |format|
      format.xml {render :xml => @instrument.categories }
      format.json {render :json => @instrument.categories }
    end
  end
end
