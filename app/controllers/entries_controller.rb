class EntriesController < ApplicationController
  before_filter :authenticate
  before_filter :manager, :only => :log
  before_filter :allowed_to_edit, :only => [:edit, :update]
  #before_filter :not_invoiced, :only => [:edit, :update]
  
  respond_to :json, :html
  
  def index
    @entries = current_user.entries( :order => 'date_run')
  end
  
  def charts
    grouping = params[:group]
    respond_to do |format|
      format.html
    end 
  end
  
  def chart_data
    report = params[:report]
    if report == 'instrument_count'
      @data = Entry.instrument_count.to_json
    elsif report == 'instrument_hours'
      @data = Entry.instrument_hours.to_json
    elsif report == 'instrument_hours_year_by_year'
      @data = Entry.instrument_hours_two_years.to_json
    elsif report == 'instrument_usage_past_year'
      @data = Entry.instrument_usage_past_year
    elsif report == 'usage_and_maintenance'
      @data = Entry.usage_and_maintenance
    elsif report == 'user_totals'
      @data = Entry.user_totals_past_year
    end #if-elseif
    
    respond_to do |format|
      format.json {render :json => @data}
    end #respond_to
  end #chart_data
  
  def log
    if current_user.admin?
      @entries = Entry.all( :order => 'date_run')
    else
      @entries = Entry.where(:lab_id => current_user.lab.id)
    end
    
    respond_to do |format|
      format.html
      format.text #{render :text => @entries.to_text}
    end
  end
  
  def new
    @entry = Entry.new
  end
  
  def create
    @entry = current_user.entries.new(params[:entry])
    @entry.lab = current_user.lab
    @entry.add_pricing_to_samples unless @entry.instrument == ''
    
    if @entry.errors.empty? and @entry.save 
      redirect_to entry_path(@entry), :notice => 'Entry Successfully Saved'
    else
      render :action => 'edit'
    end
  end #create
  
  def show
    @entry = Entry.find(params[:id])
  end #show
  
  def edit
    @entry = Entry.find(params[:id])

  end #edit
  
  def update
    @entry = Entry.find(params[:id])
    updates = params[:entry]
    updates[:updated_by_id] = current_user.id
    @entry.update_attributes(updates)
    @entry.add_pricing_to_samples
    
    
    if @entry.errors.empty? and @entry.save
      redirect_to entry_path(@entry), :notice => 'Entry Successfully Saved'
    else
      render :action => 'edit'
    end
  end #update
  
  private
  
  def not_invoiced
    @entry = Entry.find(params[:id])
    @entry.has_invoice? ? (redirect_to entry_path(@entry), :notice => "Cannot edit invoinced entry") : true
  end
  
  def allowed_to_edit
    entry = Entry.find(params[:id])
    (current_user.admin? || (current_user.lab.id == entry.lab.id && current_user.manager?)) ?
      true :
      access_denied
  end
end
