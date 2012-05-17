class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]
  #filter_resource_access

  def new
    @user_session = UserSession.new
    @user = User.new
  end

  def create
    if params[:email].empty?
      flash[:error] ="please enter an email"
      redirect_to new_password_reset_path
    else
      if  @user = User.find_by_email(params[:email])
        @user.deliver_password_reset_instructions!
        flash[:notice] = "Instructions to reset your password have been emailed to you"
        redirect_to root_path
      else
        flash[:error] = "No user was found with the email:  #{params[:email]}.  Please enter a correct email."
         redirect_to new_password_reset_path
      end
    end
  end

  def edit
        @user_session = UserSession.new
  end

  def update
    @user_session = UserSession.new
    @user.password = params[:password]
    @user.password_confirmation=params[:password_confirmation]
    if @user.password.nil?
      if @user.password_confirmation.empty?
        flash[:error] = "You must enter a password, and password confirmation"
        render :action => :edit
      else
        flash[:error] = "You must enter a password"
        render :action => :edit
      end
    else
      if @user.password_confirmation.empty?
        flash[:error] = "You must enter password confirmation"
        render :action => :edit
      else
        if @user.save
            flash[:success] = "Your password was successfully updated"
            redirect_to root_path
        else
            flash[:error] = "Your passwords dont match"
            render :action => :edit
        end
      end
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account, because you waited to long to reset your password"
      redirect_to root_url
    end
  end
end