class CreateMcOptions < ActiveRecord::Migration
  def self.up
    create_table :mc_options do |t|
      t.text :content
      t.integer :value
      t.integer :question_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mc_options
  end
end
