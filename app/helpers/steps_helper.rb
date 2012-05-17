module StepsHelper
  def refresh_steps_list(goal_id)
      remote_function(
      :url => "/goals/list_steps/#{goal_id}",
      :update => "goal_#{goal_id}_step_table"
      )
  end

  def refresh_steps_list_new(goal_id)
    remote_function(
      :url => "/goals/list_steps/#{goal_id}",
      :update => "goal_#{goal_id}_step_table",
      :before => "Element.remove(\"goal_#{goal_id}_new_step_div\"), Element.show(\"goal_#{goal_id}_step_spinner\"), Element.show(\"goal_#{goal_id}_hide_steps_span\"), Element.hide(\"goal_#{goal_id}_show_steps_span\")",
      :complete => "Element.show(\"goal_#{goal_id}_step_table\"), Element.hide(\"goal_#{goal_id}_step_spinner\")"
    )
  end
  def refresh_steps_list_delete(goal, step)
    remote_function(
      :url => "/goals/list_steps/#{goal.id}",
      :update => "goal_#{goal.id}_step_table",
      :complete => "Element.hide(\"goal_#{goal.id}_spinner\"), Element.show(\"goal_#{goal.id}_step_table\"), Element.remove(\"goal_#{goal.id}_step_#{step.id}_row\")"
    )
  end

  def refresh_steps_list_edit(goal_id)
      remote_function(
      :url => "/goals/list_steps/#{goal_id}",
      :update => "goal_#{goal_id}_step_table",
      :complete => "Element.toggle(\"goal_#{goal_id}_spinner\"), Element.toggle(\"goal_#{goal_id}_step_table\")"
      )
  end

  def toggle_value_step(goal, step)
    remote_function(:url => "/goals/#{goal.id}/steps/#{step.id}/",
      :method => :put,
      :before => "Element.show('goal_#{goal.id}_step_#{step.id}_spinner'), Element.hide('goal_#{goal.id}_step_#{step.id}_row')" ,
      :complete => "Element.hide('goal_#{goal.id}_step_#{step.id}_spinner'), Element.show('goal_#{goal.id}_step_#{step.id}_row')" ,
      :with => "this.name + '=' + this.checked"
    )
  end
end

