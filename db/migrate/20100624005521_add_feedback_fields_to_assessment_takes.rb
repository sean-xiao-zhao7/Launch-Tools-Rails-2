class AddFeedbackFieldsToAssessmentTakes < ActiveRecord::Migration
  def self.up
    change_table :assessment_takes do |t|
        t.integer :parent_id
        t.integer :contact_id
        t.boolean :is_completed
        t.string :token
    end
  end

  def self.down
      change_table :assessment_takes do |t|
        t.remove :parent_id
        t.remove :contact_id
        t.remove :is_completed
        t.remove :token
     end
  end
end
