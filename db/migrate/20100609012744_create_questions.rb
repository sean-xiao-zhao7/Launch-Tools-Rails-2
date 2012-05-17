class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :question_type_id
      t.text :content
      t.integer :assessment_id
      t.integer :category_id
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
