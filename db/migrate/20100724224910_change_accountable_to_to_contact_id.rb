class ChangeAccountableToToContactId < ActiveRecord::Migration
  def self.up
    add_column :steps, :contact_id, :integer
    remove_column :steps, :accountable_to
  end

  def self.down
    remove_column :steps, :contact_id
    add_column :steps, :accountable_to, :string
  end
end
