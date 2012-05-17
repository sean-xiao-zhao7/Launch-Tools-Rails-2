class AddBlockFeedbackPermissionToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :block_feedback, :boolean
  end

  def self.down
    remove_column :groups, :block_feedback
  end
end
