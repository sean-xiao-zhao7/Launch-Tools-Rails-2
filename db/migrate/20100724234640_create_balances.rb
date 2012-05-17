class CreateBalances < ActiveRecord::Migration
  def self.up
    create_table :balances do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :balance

      t.timestamps
    end
  end

  def self.down
    drop_table :balances
  end
end
