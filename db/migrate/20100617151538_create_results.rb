class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :result_type_id
      t.integer :assessment_id
      t.boolean :is_feedback

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
