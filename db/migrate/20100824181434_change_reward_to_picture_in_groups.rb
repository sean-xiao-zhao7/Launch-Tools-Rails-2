class ChangeRewardToPictureInGroups < ActiveRecord::Migration
  def self.up
    rename_column :groups, :reward_file_name, :picture_file_name
    rename_column :groups, :reward_content_type, :picture_content_type
    rename_column :groups, :reward_file_size, :picture_file_sizes
    rename_column :groups, :reward_updated_at, :picture_updated_at
  end

  def self.down
    rename_column :groups, :picture_file_name, :reward_file_name
    rename_column :groups, :picture_content_type, :reward_content_type
    rename_column :groups, :picture_file_sizes, :reward_file_size
    rename_column :groups, :picture_updated_at, :reward_updated_at    
  end
end
