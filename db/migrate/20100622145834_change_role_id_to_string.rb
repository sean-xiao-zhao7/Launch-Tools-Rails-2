class ChangeRoleIdToString < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
        t.remove :role_id
        t.string :role
    end
  end

  def self.down
      change_table :users do |t|
         t.remove :role
         t.integer :role_id
     end
  end
end
