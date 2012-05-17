class CreateMcAnswers < ActiveRecord::Migration
  def self.up
    create_table :mc_answers do |t|
      t.integer :mc_option_id
      t.integer :question_id
      t.integer :assessment_take_id
      t.boolean :set

      t.timestamps
    end
  end

  def self.down
    drop_table :mc_answers
  end
end
