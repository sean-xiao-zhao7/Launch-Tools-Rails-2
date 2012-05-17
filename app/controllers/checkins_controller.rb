class CheckinsController < ApplicationController
    
  before_filter :set_goal_step
  
  filter_resource_access
  filter_access_to :index => false
  
  def index
    @checkins = @step.scheduled_checkins
    #@step.checkins += @checkins
    #@new_checkin = Checkin.new if @step.can_checkin?
    if @step.can_checkin?
      start_date = @checkins[-1].nil? ? @step.previous_due_date : @checkins[-1].until_date 
      @new_checkin = Checkin.new(:start_date => start_date, :until_date => Date.today)
      @checkins << @new_checkin
    end
    render "index.html"
  end
  
  def new
    @checkin = Checkin.new(:reminder_times_actual => 0)    
    render "new.html"
  end

  def create
    @checkin = Checkin.new(params[:checkin])
    @checkin.set_default_values(@step)     
    respond_to do |format|
      begin
        @checkin.save!
        format.html { redirect_to :back }
        format.js
      rescue ActiveRecord::RecordInvalid => invalid        
        @error = invalid.message        
        if @error == "Validation failed: Reminder times actual is not a number"
          format.html { redirect_to :back }
          format.js { render "invalid_create_number" }          
        else
          format.html { redirect_to :back }
          format.js { render "invalid_create_others" }   
        end
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.xml
  def destroy
    @checkin = Checkin.find(params[:id])
    @checkin.destroy
    respond_to do |format|
      format.html { redirect_to goals_path }
      format.js
    end
  end   
   
  def delete
    @checkin = Checkin.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end  
  
private
  def set_goal_step
    @step = Step.find(params[:step_id])
    @goal = Goal.find(params[:goal_id])
  end  
end
