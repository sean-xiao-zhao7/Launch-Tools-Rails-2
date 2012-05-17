class AddValueToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :value, :integer
  end

  def self.down
    remove_column :questions, :value
  end
end
