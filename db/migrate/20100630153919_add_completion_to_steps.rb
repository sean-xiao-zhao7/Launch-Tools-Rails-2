class AddCompletionToSteps < ActiveRecord::Migration
  def self.up
    add_column :steps, :completed, :boolean
  end

  def self.down
    remove_column :steps, :completed
  end
end
