class AddReminderToSteps < ActiveRecord::Migration
  def self.up
    add_column :steps, :reminder_type, :string

    add_column :steps, :reminder_freq, :integer
    add_column :steps, :reminder_checkin_date, :date

    add_column :steps, :reminder_times_target, :integer
    add_column :steps, :reminder_times_actual, :integer

  end

  def self.down
    remove_column :steps, :reminder_type
    remove_column :steps, :reminder_freq
    remove_column :steps, :reminder_times_target
    remove_column :steps, :reminder_times_actual
    remove_column :steps, :reminder_checkin_date
  end
end
