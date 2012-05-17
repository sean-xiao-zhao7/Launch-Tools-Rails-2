class CleanUpSteps < ActiveRecord::Migration
  def self.up
    remove_column :steps, :due_date
    remove_column :steps, :reminder_freq    
  end

  def self.down
    add_column :steps, :due_date, :date
    add_column :steps, :reminder_freq, :integer        
  end
end
