class ProjectsController < ApplicationController
  before_filter :authenticate
  before_filter :admin
  
  def index
    @projects = Project.all
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    
    if @project.save
      redirect_to projects_path, :notice => 'Project successfuly created'
    else
      render :action => 'edit'
    end
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to projects_path, :notice => 'Project successufully updated'
    else
      render :action => 'edit'
    end
  end
  
end
