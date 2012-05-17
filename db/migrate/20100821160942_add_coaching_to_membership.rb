class AddCoachingToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :coach_id, :integer
    add_column :memberships, :coach_status, :string
  end

  def self.down
    remove_column :memberships, :coach_status
    remove_column :memberships, :coach_id
  end
end
