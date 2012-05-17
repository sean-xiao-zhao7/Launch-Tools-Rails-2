class AddRewardPicToGoals < ActiveRecord::Migration
  def self.up
    add_column :goals, :reward_pic, :binary # Original filename
  end

  def self.down
    remove_column :goals, :reward_pic
  end
end
