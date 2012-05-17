class AdminEditUserController < ApplicationController

  def index
    @user = User.find(:all)
  end

  def edit
     @user = User.find(params[:id])
  end

  def update

  end

  def destroy_user
    @user = User.find(params[:d])

    if @user.destroy
       flash[:success] = 'User was assassinated!!!'
       redirect_to "/admin_edit_user/"
    else
      flash[:error] ="User escaped your assassination"
      redirect_to "/admin_edit_user/"
    end
  end

end
