class LabsController < ApplicationController
  before_filter :authenticate
  before_filter :admin
  
  def index
    @labs = Lab.all
  end
  
  def new
    @lab = Lab.new
  end
  
  def create
    @lab = Lab.new(params[:lab])
    
    if @lab.save
      redirect_to labs_path, :notice => 'User successfuly updated'
    else
      render :action => 'edit'
    end
  end
  
  def show
    @lab = Lab.find(params[:id])
  end
  
  def edit
    @lab = Lab.find(params[:id])
  end
  
  def update
    @lab = Lab.find(params[:id])
    if @lab.update_attributes(params[:lab])
      redirect_to labs_path, :notice => 'Lab successufully updated'
    else
      render :action => 'edit'
    end
  end
end
