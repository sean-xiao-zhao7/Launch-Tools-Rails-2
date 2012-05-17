class ChangeGoalsReward < ActiveRecord::Migration
  def self.up
    change_column :goals, :reward_pic, :string
  end

  def self.down
    change_column :goals, :reward_pic, :binary
  end
end
