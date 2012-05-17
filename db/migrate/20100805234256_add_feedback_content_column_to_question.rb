class AddFeedbackContentColumnToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :feedback_content, :text
  end

  def self.down
    remove_column :questions, :feedback_content
  end
end
