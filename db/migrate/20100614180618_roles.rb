class Roles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string    :role
    end
  end

  def self.down
        drop_table :roles
  end
end
