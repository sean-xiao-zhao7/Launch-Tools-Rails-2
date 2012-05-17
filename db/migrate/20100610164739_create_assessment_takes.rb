class CreateAssessmentTakes < ActiveRecord::Migration
  def self.up
    create_table :assessment_takes do |t|
      t.integer :user_id
      t.integer :assessment_id

      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_takes
  end
end
