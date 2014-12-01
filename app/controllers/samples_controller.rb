class SamplesController < ApplicationController
  before_filter :authenticate
  before_filter :manager
  
  def destroy
    @entry = Entry.find(params[:entry_id])
    if current_user.admin? || (current_user.lab.id == @entry.lab.id && current_user.manager?)
      @sample = Sample.find(params[:id])
      @sample.delete
    end
    redirect_to entry_path(@entry)
  end
  
end
