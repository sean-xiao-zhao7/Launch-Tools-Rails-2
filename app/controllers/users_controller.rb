class UsersController < ApplicationController
  before_filter :require_no_user, :only => []
  before_filter :set_params_id, :only => [:edit, :update, :password_check, :password, :show, :user_email, :send_user_email]
  before_filter :set_title, :only => [:index, :create, :user_email]
  before_filter :process_invitation, :only => [:new]
  
  filter_resource_access

  def index    
    @users = User.find(:all) do
      if params[:_search] == "true"        
        last_name  =~ "%#{params[:last_name]}%" if params[:last_name].present?
        first_name =~ "%#{params[:first_name]}%" if params[:first_name].present?        
        gender     =~ "%#{params[:gender]}%" if params[:gender].present?
        birth_date =~ "%#{params[:birth_date]}%" if params[:birth_date].present?
        country    =~ "%#{params[:country]}%" if params[:country].present?
        email      =~ "%#{params[:email]}%" if params[:email].present?      
        verified   =~ "%#{params[:verified]}%" if params[:verified].present?
        role       =~ "%#{params[:role]}%" if params[:role].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]      
      order_by "#{params[:sidx]} #{params[:sord]}"
    end    
    respond_to do |format|
      format.html
      format.json { render :json => @users.to_jqgrid_json([:last_name, :first_name, :gender, :birth_date, :country, :email, :verified, :role], 
                                                       params[:page], params[:rows], @users.total_entries) }
    end

  end

  def user_email
    @user = User.find(params[:id])
  end

  def send_user_email
    @user = params[:form][:email]
    email = params[:form][:email]
    subject = params[:form][:subject]
    text = params[:form][:text]
    UserMailer.deliver_send_user_email(email, subject, text, current_user)
    redirect_to users_path
  end

  def new
    if current_user
      @title = "Admin"
    else
      @title = "Sign Up"
    end
    @user_session = UserSession.new
    @user = User.new

    # Follow up to the process_invitation method
    if @invitation
      @user.email = @invitation.email
      @user.first_name = @invitation.first_name
      @user.last_name = @invitation.last_name
    end
  end

  def create
     @user = User.new(params[:user])
     @user.verified = true
     
     if current_user
        if @user.save
          flash[:notice] = "Account registered!, An email will be sent to the created user"
          if @user.verified?
            redirect_to users_path
          else
            redirect_to users_path
          end
        else
          render :action => :new
        end
     elsif @user.save
        @user.accept_invitations_by_id(params[:invitation_ids]) if params[:invitation_ids]
        flash[:notice] = "Account registered!"
        redirect_to root_path
     else
        flash[:error] = "Account Creation Failed"
        @user_session = UserSession.new
        process_invitation if params[:invitation_token]
        render :action => :new
      end
  end

  def show
    @user = User.find(params[:id])
    if @user != current_user
      @title = "Admin"
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      @title = "Admin"
    end
  end

  def update
    @user = User.find(params[:id])
    user=@user
    old_email = @user.email
    #params[:user][:birth_date] = datepicker( "getDate" )
      if @user.update_attributes(params[:user])
        flash[:success]="account changes saved!"
         if @user == current_user
           redirect_to show_path(:id => current_user.id)
         else
           redirect_to users_path
        end
      else
           render :action => :edit
      end
  end

  def password
    @user = current_user
  end

  def password_check
    @user = current_user
    old_email = @user.email

    if current_user.valid_password?(params[:form][:current_password])

      if params[:form][:password].empty? && params[:form][:password_confirmation].empty?
        if params[:form][:email]== current_user.email
           flash[:notice] = "nothing was changed"
        else
          @user.email = params[:form][:email]
          if @user.save
              flash[:success] = "Your email has been changed"
          else
              flash[:error] = "Your new email does not exist!"
          end
        end

      elsif params[:form][:email].empty? || params[:form][:email] == current_user.email
        @user.password = params[:form][:password]
        @user.password_confirmation = params[:form][:password_confirmation]
        if params[:form][:password].length >= 4
          if @user.save
            user=@user
            flash[:success] = "Your password has been changed"
          else
            flash[:error] = "Your passwords do not match"
          end
        else
          flash[:error] = "your new password is too short"
        end

      else
          if params[:form][:password].length >=4

            @user.password = params[:form][:password]
            @user.password_confirmation = params[:form][:password_confirmation]
            @user.email = params[:form][:email]

            if @user.save
              user=@user
              flash[:success] = "Email and Password successfully change"
            elsif params[:form][:password] == params[:form][:password_confirmation]
              flash[:error] = "failed, passwords dont match"
            else
              flash[:error] = "Your email doesn't exist"
            end
          else
              flash[:error] = "your password is too short"
          end
      end

    elsif params[:form][:current_password].empty?
      if params[:form][:password].empty? && params[:form][:password_confirmation].empty?
        if current_user.email == old_email
          flash[:notice] = "Nothing was changed"
        else
          flash[:error] = "you cannot change your email without your current password"
        end
      else
        flash[:notice] = "you cannot change these attributes without your current password"
      end
    else
      flash[:error] = "Your current password is incorrect"
    end
    redirect_to "/users/password/1"
    #redirect_to edit_account_path
  end

  def destroy
    @user = User.find(params[:id]) 
    return if current_user == @user # Self-delete is not allowed, no paradox
    if @user.destroy
       flash[:success] = 'User was successfully deleted' #UserMailer.deliver_account_destroyed(user)
       respond_to do |format|
         format.html { redirect_to users_path }
       end
    else
      flash[:error] ="User deletion failed due to errors"
      redirect_to users_path
    end
  end
  
  def get_contacts_names
    @contacts = current_user.contacts.collect { |c| c if c.title =~ /#{params[:term].lstrip}/i }
    @contacts.compact!
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def get_contacts_emails
    @contacts = current_user.contacts.collect { |c| c if c.email =~ /#{params[:term].lstrip}/i }
    @contacts.compact!
    respond_to do |wants|
      wants.html
      wants.js
    end
  end

  private

  def set_params_id
    params[:id] ||= current_user.id
  end

  def set_title
    @title = "Admin"
  end

  def process_invitation
    @invitation = Invitation.find_by_token(params[:invitation_token]) if params[:invitation_token]
    @group_invitations = Invitation.find_all_by_email(@invitation.email) if @invitation
  end
end