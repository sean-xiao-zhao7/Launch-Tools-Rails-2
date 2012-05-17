class AddAndRenameColumnsToTransactions < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :points, :tokens
    add_column :transactions, :group_name, :string
    add_column :transactions, :assessment_id, :integer
  end

  def self.down
    rename_column :transactions, :tokens, :points
    remove_column :transactions, :assessment_id
    remove_column :transactions, :group_name
  end
end
