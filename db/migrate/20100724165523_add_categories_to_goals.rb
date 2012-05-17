class AddCategoriesToGoals < ActiveRecord::Migration
  def self.up
    add_column :goals, :category, :string
  end

  def self.down
    remove_column :goals, :category
  end
end
