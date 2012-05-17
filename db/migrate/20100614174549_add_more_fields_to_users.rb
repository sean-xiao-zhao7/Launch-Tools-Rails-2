class AddMoreFieldsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
        t.string :first_name
        t.string :last_name
        t.string :gender
       t.date :birth_date
       t.integer :country
       t.string :province_or_state
       t.integer :role_id
    end
  end

  def self.down
      change_table :users do |t|
        t.remove :first_name
        t.remove :last_name
        t.remove :gender
       t.remove :birth_date
       t.remove :country
       t.remove :province_or_state
       t.remove :role_id
     end
  end
end
