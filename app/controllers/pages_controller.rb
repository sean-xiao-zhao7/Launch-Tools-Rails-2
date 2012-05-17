class PagesController < ApplicationController

  filter_resource_access

  filter_access_to :home, :attribute_check => false

  def index
    @title = "Dashboard"
    @current_user = current_user
    @user_session = UserSession.new
    unless current_user.nil?
      @assessments = current_user.available_assessments.sort_by(&:title)
      @assessment_takes = current_user.assessment_takes
      @assessment_tokens = current_user.assessment_tokens
      @invitations = Invitation.find_all_by_email_and_status(current_user.email, 'Invited')
      @steps = current_user.goals.collect{ |goal| goal.steps }.flatten.collect{ |step| step unless step.checkin_date.nil? or step.completed }.compact.sort_by{ |step| step.reminder_checkin_date }[0, 5]      
    end
  end

  def home
    @title = "Home"
  end
end
