class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.integer :assessment_id
      t.integer :parent_id
      t.integer :prev_id
      t.integer :next_id

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
