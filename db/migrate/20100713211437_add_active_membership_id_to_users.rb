class AddActiveMembershipIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active_membership_id, :integer
  end

  def self.down
    remove_column :users, :active_membership_id
  end
end