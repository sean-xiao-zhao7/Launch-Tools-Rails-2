class AddCompletedToAssessments < ActiveRecord::Migration
  def self.up
    add_column :assessments, :completed, :boolean
  end

  def self.down
     remove_column :assessments, :completed
  end
end
