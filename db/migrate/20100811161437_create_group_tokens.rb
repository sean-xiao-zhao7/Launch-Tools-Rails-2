class CreateGroupTokens < ActiveRecord::Migration
  def self.up
    create_table :group_tokens do |t|
      t.string :name
      t.integer :tokens
      t.integer :owner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_tokens
  end
end
