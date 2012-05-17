class AddAttachmentsRewardToGoal < ActiveRecord::Migration
  def self.up
    add_column :goals, :reward_file_name, :string
    add_column :goals, :reward_content_type, :string
    add_column :goals, :reward_file_size, :integer
    add_column :goals, :reward_updated_at, :datetime
  end

  def self.down
    remove_column :goals, :reward_file_name
    remove_column :goals, :reward_content_type
    remove_column :goals, :reward_file_size
    remove_column :goals, :reward_updated_at
  end
end
