class UserVerificationController < ApplicationController
 before_filter :load_user_using_perishable_token
  #before_filter :set_params_id, :only => [:show]

  def show
    if @user
      @user.verify!
      flash[:notice] = "Your account has been verified. You may now login."
    end
    redirect_to root_url
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    flash[:notice] = "Unable to find your account." unless @user
  end
end

