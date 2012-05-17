class StepsController < ApplicationController

  before_filter :set_title
  
  before_filter :set_freq, :only => [:new, :create, :checkin]
  before_filter :set_type, :only => [:new, :create ]
  
  before_filter :find_step, :only => [:review_progress, :show, :edit, :update, :destroy, :checkin]
  before_filter :find_goal, :except => [:index ]
  
  filter_resource_access
  
  def index
    redirect_to goals_path
  end

  def show    
    redirect_to goals_path
  end

  # GET /steps/1/edit
  def edit    
    @type = @step.reminder_type
    respond_to do |format|
      format.html
      format.js 
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
    @step = Step.new(:description => "Your New Step", :reminder_type => "Once")
    render "new.html"
    #respond_to do |format|
    #  format.html { render :partial => "form" }
    #  format.js
    #end
  end

  # POST /steps
  # POST /steps.xml
  def create
    @step.set_default_values
    @step.goal_id = @goal.id
    respond_to do |format|
      begin 
        @step.save!
        format.html { redirect_to goals_path }
        format.js
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:error] = invalid.message
        format.html { redirect_to goals_path }
        format.js { render "error" }
      end 
    end
  end
  
  def update
    params[:step][:checkins_attributes] = @step.flatten_checkins(params[:step][:checkins_attributes]) if params[:step][:checkins_attributes]
    respond_to do |format|
      if @step.update_attributes(params[:step])
        @late = @step.late?
        format.html { redirect_to goals_path }
        format.js do
          if @goal.all_steps_completed?
            render "update_complete_all"
          else
            render "update"
          end
        end
      else        
        flash[:error] = "Invalid Input(s)"
        format.html { redirect_to goals_path }
        format.js { render "error" }
      end
    end
    #if params[:step][:reminder_type] != "Once" and params[:step][:reminder_type] != nil # For type Once the user picks the date, the other two are calculated
    #  params[:step][:reminder_checkin_date] = @step.get_due_date(params[:step][:reminder_type])
    #end
    #if params[:step][:reminder_times_target_monthly] == "" or params[:step][:reminder_times_target_weekly] == ""
    #  params[:step][:reminder_times_target_monthly] = "0" # the user did not enter a number, use zero
    #  params[:step][:reminder_times_target_weekly] = "0" 
    #end    
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy    
    @step.destroy
    respond_to do |format|
      format.html { redirect_to goals_path }
      format.js
    end
  end

  def delete
    respond_to do |format|
      format.html { render "delete" }
      format.js
    end
  end
  
  def add_accountability
    @contact = Contact.new
  end
  
  def create_accountability
    if params[:new_contact] == "true"
      # The user wants to add a new contact
      @contact = Contact.new({:first_name => params[:contact][:first_name],:last_name => params[:contact][:last_name],:email => params[:contact][:email], :user_id => current_user.id})
      begin
        @contact.save!
        @step.accountable_to = @contact
        #send_accountability_confirmation(current_user, @step, @contact) unless params[:send_mail] == "1"
      rescue ActiveRecord::RecordInvalid => invalid 
        if invalid.message  == 'Validation failed: Email has already been taken'# consider using jquery validates
          flash[:error] = 'This person is already in your list of contacts.'
        end
      end
    else
      # Find the contact if the contact exists.
      @contact = Contact.find(params[:contact]["id"]) if !params[:contact]["id"].nil?
      @contact ||= Contact.find_by_email_and_user_id(params[:contact]["email"], current_user.id)
      if params[:contact][:email] == current_user.email
        flash[:error] = "You cannot add yourself."
      else      
        @step.accountable_to = @contact
        #send_accountability_confirmation(current_user, @step, @contact) unless params[:send_mail] == "1"
      end
    end
    respond_to do |format|
      format.html { redirect_to goals_path }
      if flash[:error]  
        format.js { render "error"}
      else
        format.js { render "accountability"}
      end
    end
    
  end
  
  # Feedback Users
  # @assessment_take is pre-initialized
  def send_accountability_confirmation(user, step, contact)
     UserMailer.send_accountability_confirmation(user, step, contact)
  end  
  
  def review_progress
    render "review_progress"
  end
    
private
  def set_title
    @title = "Growth Plan"
  end
  
  def set_freq
    @reminder_freqs = ["Weekly", "Monthly"]
  end

  def set_type
    @reminder_types = ["One Time", "Repeated"]
  end
  
  def find_step
    @step = Step.find(params[:id])
  end
  
  def find_goal
    @goal = Goal.find(params[:goal_id])
  end
end