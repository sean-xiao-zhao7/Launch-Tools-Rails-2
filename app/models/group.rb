class Group < ActiveRecord::Base

  # Memberships
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  
  has_many :transactions, :dependent => :destroy
  has_many :balances, :dependent => :destroy
  has_many :invitations, :dependent => :destroy

  validates_presence_of :name
  
  has_attached_file :picture, :default_url => "/images/groups/missing.png", :url => "/images/groups/:id-:name/:basename.:extension"
  validates_attachment_content_type :picture, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :unless => Proc.new {|group| group[:picture].nil?}
  validates_attachment_size :picture, :less_than => 500.kilobytes, :unless => Proc.new {|group| group[:picture].nil?}  

  # To Check if a file has been chosen
  # :if => Proc.new { |imports| !imports.photo_file_name.blank?
  # validates_attachment_size :image, :less_than => 25.megabytes, :unless => Proc.new {|m| m[:image].nil?}
  
  # Validation only works with groups you create now, old groups WILL crash if they do NOT have a picture already uploaded, because the following checks if the picture/picture_size column is nil or not  
  
  #validates_attachment_size :picture, :less_than => 2.megabytes
  #validates_attachment_content_type :picture, :content_type => /image/, :message => "must be an image"

  # Invitations
  accepts_nested_attributes_for :invitations

  # Assessment Tokens
  has_many :assessment_tokens

  def owner
    (owner_id)? User.find(owner_id) : nil
  end

  def owner=(user)
    self.owner_id = user.id
  end

  # Note: Owner methods get and set by the id of the user.
  # Get Owner
  def owner_id
    owner_role = Role.find_by_name('Owner')
    owner_membership = Membership.find_by_group_id_and_role_id(self.id, owner_role)
    (!owner_membership.nil?)? owner_membership.user_id : nil
  end

  # Note: Owner methods get and set by the id of the user.
  # Set Owner
  def owner_id=(user_id)
    # Make sure the user isn't already the owner
    return true if user_id == owner_id

    # Demote the previous owner of the group, if any
    cur_owner_membership = Membership.find_by_user_id_and_group_id(owner_id, self.id)
    if !cur_owner_membership.nil?
      cur_owner_membership.role = Role.find_by_name('Head-Coach')
      cur_owner_membership.save
    end

    # Make the given user the owner of the group
    membership = Membership.find_or_create_by_user_id_and_group_id(user_id, self.id)
    membership.role = Role.find_by_name('Owner')
    membership.save
  end

  def send_invitation_emails
    invitations = self.invitations.find_all_by_status('Uninvited')

    invitations.each do |invitation|
      # Make sure the invitation is not sent already - in case the delayed job failed
      if invitation.status != 'Invited'
        user = User.find_by_email(invitation.email)

        # Process each email as a seperate delayed job - because they are retried if they fail.
        if user
          UserMailer.delay.deliver_invite_existing_user( user, self )
        else
          UserMailer.delay.deliver_invite_new_user( invitation, self )
        end

        # TODO: Errors in saving
        invitation.status = 'Invited'
        invitation.save
      end
    end
  end

  # Custom Group Roles
  # Encode custom group role to internal role
  # "Coach" -> "Mentor"
  def encode(role)
    case role
      when "Group Creator"
        "Owner"
      when self.head_coach_title
        "Head-Coach"
      when self.coach_title
        "Coach"
      when self.student_title
        "Student"
      else
        # Resort to lowest role if the role string
        # is unexpected
        "Student"
    end
  end

  # Decode internal role name to custom group role
  # "Mentor" -> "Coach"
  def decode(group_role)
    case group_role
      when "Owner"
        "Group Creator"
      when "Head-Coach"
        (self.head_coach_title)? self.head_coach_title : group_role
      when "Coach"
        (self.coach_title)? self.coach_title : group_role
      when "Student"
        (self.student_title)? self.student_title : group_role
      else
        # Resort to lowest role if the role string
        # is unexpected
        "Student"
    end
  end

  # Below methods return memberships.
  def coaches
    student_role = Role.find_by_name('Student')
    self.memberships.find(:all, :conditions => [ "role_id != ?", student_role.id ])
  end

  def uncoached_students
    student_role = Role.find_by_name('Student')
    self.memberships.find(:all, :conditions => [ "coach_id = nil and role_id != ?", student_role.id ])
  end

  def students
    student_role = Role.find_by_name('Student')
    self.memberships.find(:all, :conditions => [ "role_id = ?", student_role.id ])
  end

end