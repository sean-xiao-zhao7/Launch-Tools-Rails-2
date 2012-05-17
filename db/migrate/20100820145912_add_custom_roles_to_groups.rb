class AddCustomRolesToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :head_coach_title, :string
    add_column :groups, :coach_title, :string
    add_column :groups, :student_title, :string
  end

  def self.down
    remove_column :groups, :student_title
    remove_column :groups, :coach_title
    remove_column :groups, :head_coach_title
  end
end
