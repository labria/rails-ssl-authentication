# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
    if request.env["HTTP_X_SSL_CLIENT_S_DN"]
      pairs = request.env["HTTP_X_SSL_CLIENT_S_DN"].split("/").
        delete_if{ |x| x == ""}.map{|p| p.split("=")}.flatten
      @info = Hash.[](*pairs)
      if user = User.find_by_login_and_email(@info["CN"], @info["emailAddress"])
        self.current_user = user
        flash[:notice] = "Logged in via cert successfully"
        redirect_to :controller => 'test', :action => 'cert_login'
      end
    end
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
