class AddFeedbackContentColumnToMcOption < ActiveRecord::Migration
  def self.up
    add_column :mc_options, :feedback_content, :text
  end

  def self.down
    remove_column :mc_options, :feedback_content
  end
end
