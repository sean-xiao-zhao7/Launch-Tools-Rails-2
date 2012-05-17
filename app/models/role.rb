class Role < ActiveRecord::Base
  has_many :memberships
  has_many :invitations
end
