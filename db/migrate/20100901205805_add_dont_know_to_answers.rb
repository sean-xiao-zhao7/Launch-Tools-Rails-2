class AddDontKnowToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :dont_know, :boolean
  end

  def self.down
    remove_column :answers, :dont_know
  end
end
