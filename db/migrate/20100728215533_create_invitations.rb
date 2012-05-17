class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :sender_id
      t.integer :group_id
      t.string :token
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
