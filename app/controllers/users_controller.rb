class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :admin, :only => [:new, :create, :index]
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end #new
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path, :notice => 'User successfully added'
    else
      render :action => 'new'
    end
  end #create
  
  def edit
    if current_user.admin? && !params[:id].nil? && User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end #edit
  
  def update
    if current_user.admin? && !params[:id].nil? && User.exists?(params[:id])
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    
    if @user.update_attributes(params[:user])
      redirect_to root_path, :notice => 'User successufully updated'
    else
      render :action => 'edit'
    end
  end #update
  
end
