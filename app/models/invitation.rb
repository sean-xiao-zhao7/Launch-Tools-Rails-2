class Invitation < ActiveRecord::Base

  belongs_to :sender,
             :class_name => "User",
             :foreign_key => "sender_id"
  belongs_to :group
  belongs_to :role

  include TokenGenerator
  before_create :set_token

  validates_presence_of :sender_id, :email, :role_id  
  validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :message => "Must be a valid email address"

  # TODO: make email unique to the scope of the group
  # Turned off for testing
  # validates_uniqueness_of :email, :scope => :group_id

end
