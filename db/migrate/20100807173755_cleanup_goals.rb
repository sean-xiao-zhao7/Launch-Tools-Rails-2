class CleanupGoals < ActiveRecord::Migration
  def self.up
    remove_column :goals, :reward_pic
  end

  def self.down
    add_column :goals, :reward_pic, :string
  end
end
