class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
      t.integer :reminder_times_actual
      t.integer :reminder_times_target
      t.date :reminder_checkin_date
      
      t.integer :step_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :checkins
  end
end
