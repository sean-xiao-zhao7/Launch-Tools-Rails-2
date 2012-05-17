class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :transaction_type
      t.integer :user_id
      t.integer :group_id
      t.string :gift_email
      t.integer :points
      t.integer :cost
      t.string :token
      t.string :transaction_id
      t.text :params
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
