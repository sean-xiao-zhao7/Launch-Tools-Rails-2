module GoalsHelper
  def toggle_value(object)
    remote_function(:url => url_for(object),
        :method => :put,
        :with => "this.name + '=' + this.checked"
      )
  end

  def new_goal_proc()
    "Element.show('new_goal_spinner'), Element.hide('new_goal_div')"
  end

  def refresh_goals()
    remote_function(
      :url => '/goals/index',
      :update => "goals_index"
    )
  end

  def deletion_cleanup(goal)
    remote_function(
      :url => "/goals/index/",
      :update => "goals_index",
      :complete => "Element.remove(\"goal_#{goal.id}_spinner\"), Element.remove(\"goal_#{goal.id}_table\"), Element.remove(\"goal_#{goal.id}_table_edit\")"
    )
  end

  def show_steps(goal)
   # - Switch "Show Steps" with "Hide Steps".
   # - Shows the steps (goal_###_step_table).
    "Element.hide(\"goal_#{goal.id}_show_steps_span\"), Element.hide(\"goal_#{goal.id}_spinner\"),
    Element.show(\"goal_#{goal.id}_hide_steps_span\"), Element.show(\"goal_#{goal.id}_step_table\")"
  end

  def hide_steps(goal)
    # - Switch "Hide Steps" with "Show Steps".
    # - Hides the steps (goal_###_step_table).
    "Element.hide(\"goal_#{goal.id}_hide_steps_span\"), Element.show(\"goal_#{goal.id}_show_steps_span\"),   Element.update(\"goal_#{goal.id}_step_table\", '')"
  end

  def can_checkin(goal, step)
    if step.completed
      "Completed"
    elsif step.reminder_checkin_date != Date.today
      link_to "Check In!", "#", :onclick => "alert(\"Today is not the checkin date!\")"
    elsif step.reminder_type != "Repeated"
      link_to "Check In!", "#", :onclick => "alert(\"This step is not a repeated type.\")"
    elsif (@late_days = Date.today - step.reminder_checkin_date) > 0
      link_to "Late for Check In!", { :goal_id => goal.id, :id => step.id, :controller => :steps, :action => "checkin", :late => @late_days }, :onclick => "alert(\"You are #{@late_days} days late!\")"
    else
      link_to "Check In!", { :goal_id => goal.id, :id => step.id, :controller => :steps, :action => "checkin" }
    end
  end

end