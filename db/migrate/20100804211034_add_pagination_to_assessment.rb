class AddPaginationToAssessment < ActiveRecord::Migration
  def self.up
    add_column :assessments, :pagination, :integer
  end

  def self.down
    remove_column :assessments, :pagination
  end
end
