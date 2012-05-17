class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :role

  #Not needed
  #has_one :active_user, :class_name => "User", :foreign_key => "active_membership_id"
  belongs_to :coach, :class_name => "User", :foreign_key => "coach_id"
  # Coach Statuses:
  #   Awaiting Acceptance
  #   Accepted
  #   Rejected


  validates_presence_of :user_id, :group_id, :role_id
  validates_uniqueness_of :user_id, :scope => :group_id

  def name
    #TODO: Take out the " - " + user.name
    self.group.name + " - " + self.user.name + " - " + self.role.name
  end

  def activate
    user = self.user
    user.active_membership = self
    user.save
  end

  def deactivate
    user = self.user
    user.active_membership = nil
    user.save    
  end

  # group_role sets or returns the custom role for the group.

  def group_role
    group.decode(role.name)
  end

  def group_role=(name)
    self.role = Role.find_by_name(group.encode(name))
  end

end