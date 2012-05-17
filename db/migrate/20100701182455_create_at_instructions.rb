class CreateAtInstructions < ActiveRecord::Migration
  def self.up
    create_table :at_instructions do |t|
      t.integer :assessment_id
      t.text :intro
      t.text :main
      t.text :pre_take
      t.text :fb_welcome
      t.text :fb_save
      t.text :fb_submit

      t.timestamps
    end
  end

  def self.down
    drop_table :at_instructions
  end
end
