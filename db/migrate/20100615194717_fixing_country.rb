class FixingCountry < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
        change_column(:users, :country, :string)
    end
  end

  def self.down
      change_table :users do |t|
        change_column(:users, :country, :integer)
     end
  end
end