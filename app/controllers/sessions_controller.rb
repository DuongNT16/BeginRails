class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by email: params[:session][:email].downcase
  	if user && user.authenticate(params[:session][:password])
  	  if user.activated?
        log_in user
        params[:session][:remember_me] == Settings.one ? remember(user) : forget(user)
        redirect_back_to user
      else
        message = t "controller.sessions.not_activate"
        flash[:warning] = message
        redirect_to root_url
      end
  	else
  	  flash.now[:danger] = t "views.sessions.new.invalid_email"
  	  render :new
  	end
  end

  def destroy                   
    log_out if logged_in?
    redirect_to root_url
  end
end
