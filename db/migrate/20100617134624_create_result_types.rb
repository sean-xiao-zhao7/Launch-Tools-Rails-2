class CreateResultTypes < ActiveRecord::Migration
  def self.up
    create_table :result_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :result_types
  end
end
