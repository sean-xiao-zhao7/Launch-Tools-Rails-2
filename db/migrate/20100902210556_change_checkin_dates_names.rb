class ChangeCheckinDatesNames < ActiveRecord::Migration
  def self.up
    add_column :checkins, :start_date, :date
    add_column :checkins, :until_date, :date
  end

  def self.down
    remove_column :checkins, :start_date
    remove_column :checkins, :until_date
  end
end
