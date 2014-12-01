class SessionsController < ApplicationController
  before_filter :admin, :only => [:switch, :change]
  
  
  def create
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      redirect_to root_path #, :notice => "Logged in successfully"
    else
      flash.now[:alert] = "Invalid login/password"
      render :action => 'new'
    end
  end
  
  def destroy
    reset_session
    redirect_to login_path, :notice => "Logged out successfully"  
  end
  
  def switch
  end
  
  def change
    if current_user.admin?
      if user = User.find_by_email(params[:email])
        session[:user_id] = user.id
        redirect_to root_path, :notice => "Change account successfully"
      else
        redirect_to root_path, :notice => "Account not found"
      end
    else
      flash.now[:alert] = "Action not allowed"
      render :action => 'new'
    end
  end #change
      
end
