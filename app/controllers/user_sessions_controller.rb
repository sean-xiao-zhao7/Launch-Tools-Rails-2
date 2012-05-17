class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  filter_resource_access
  def new
    @user_session = UserSession.new
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        format.html { redirect_to root_path }
        format.js 
      else
        flash[:error] = "Wrong username and password combination."
        format.html { redirect_to new_user_session_path }
        format.js
      end
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path
  end
end