class UpgradeStep < ActiveRecord::Migration
  def self.up
    add_column :steps, :start_date, :date
    add_column :steps, :until_date, :date
    add_column :steps, :reminder_freq, :integer         
  end

  def self.down
    remove_column :steps, :start_date
    remove_column :steps, :until_date
    remove_column :steps, :reminder_freq      
  end
end
