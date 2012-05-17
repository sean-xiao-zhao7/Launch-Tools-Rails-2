class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :assessments
  end
end
