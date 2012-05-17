class CreateAssessmentTokens < ActiveRecord::Migration
  def self.up
    create_table :assessment_tokens do |t|
      t.integer :assessment_id
      t.integer :user_id
      t.string :gift_email

      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_tokens
  end
end
