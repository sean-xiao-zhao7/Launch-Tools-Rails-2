class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|

      t.string :description
      t.date :due_date
      t.string :accountable_to

      t.integer :goal_id

      t.timestamps
    end
  end

  def self.down
    drop_table :steps
  end
end
