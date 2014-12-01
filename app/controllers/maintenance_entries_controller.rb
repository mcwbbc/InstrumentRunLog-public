class MaintenanceEntriesController < ApplicationController
  before_filter :authenticate
  before_filter :admin, :only => :destroy
  
  def index
    @maintenance_entries = MaintenanceEntry.all
  end
  
  def new
    @maintenance_entry = MaintenanceEntry.new
  end
  
  def edit
    @maintenance_entry = MaintenanceEntry.find(params[:id])
  end
  
  def show
    @maintenance_entry = MaintenanceEntry.find(params[:id])
  end
  
  def create
    @maintenance_entry = current_user.maintenance_entries.new(params[:maintenance_entry])
    
    if @maintenance_entry.save
      redirect_to maintenance_entries_path, :notice => 'Entry successfuly created'
    else
      render :action => 'edit'
    end  
  end #create
  
  def update
    @maintenance_entry = MaintenanceEntry.find(params[:id])
    if @maintenance_entry.update_attributes(params[:maintenance_entry])
      redirect_to maintenance_entries_path, :notice => 'Entry successufully updated'
    else
      render :action => 'edit'
    end
  end #update
  
  def destroy
    @maintenance_entry = MaintenanceEntry.find(params[:id])
    @maintenance_entry.destroy
    
    flash[:notice] = 'Entry successfully removed'
    redirect_to maintenance_entries_path
  end
  
end
