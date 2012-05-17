class AddColumnsToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :activated, :boolean
    add_column :groups, :tokens, :integer
  end

  def self.down
    remove_column :groups, :tokens
    remove_column :groups, :activated
  end
end
