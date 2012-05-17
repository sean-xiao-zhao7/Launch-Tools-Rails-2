class Checkin < ActiveRecord::Base
  belongs_to :step
  validates_presence_of :reminder_times_actual
  validates_numericality_of :reminder_times_actual, :greater_than_or_equal_to => 0
  
  def set_default_values(step)
    self.step_id = step.id
    self.reminder_times_actual = 0 if self.reminder_times_actual.nil? || !self.reminder_times_actual.is_a?(Numeric)
    self.reminder_checkin_date = step.reminder_checkin_date
    self.reminder_times_target = step.reminder_times_target == nil ? 0 : step.reminder_times_target
    self.start_date = step.previous_due_date
    self.until_date = Date.today
  end
  
  def period
    return self.start_date.strftime("%b %d, %Y").to_s + " to " + self.until_date.strftime("%b %d, %Y").to_s
  end
end
