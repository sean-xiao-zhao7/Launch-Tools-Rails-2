class AddTextAnswers < ActiveRecord::Migration
  def self.up
    change_table :answers do |a|
      a.text :text
    end
  end

  def self.down
    change_table :answers do |a|
      a.remove :text
    end
  end
end
