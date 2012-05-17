class User < ActiveRecord::Base
  acts_as_authentic

  #belongs_to :roles
  has_many :contacts
  has_many :assessment_takes
  has_many :goals

  before_save :set_role

  def role_symbols
    @role_symbols ||= (role || []).map {|r| r.to_sym}
    #[role.to_sym]
  end

  #Groups
  has_many :memberships, :dependent => :destroy
  has_many :students, :class_name => "Membership", :foreign_key => "coach_id"
  has_many :groups, :through => :memberships
  #TODO: Active Membership is untested
  belongs_to :active_membership, :class_name => "Membership", :foreign_key => "active_membership_id"

  #Transactions
  has_many :transactions, :dependent => :destroy, :order => "updated_at DESC"

  #Points
  has_many :balances, :dependent => :destroy
  
  # Assessment Tokens
  has_many :assessment_tokens
  has_many :given_assessment_tokens,
           :class_name => "AssessmentToken",
           :foreign_key => "giver_id"

  # Invitations
  has_many    :invitations,
              :class_name => "Invitation",
              :foreign_key => "sender_id",
              :dependent => :destroy

  #Validations

  validates_presence_of :first_name, :last_name, :birth_date, :country, :email, :gender

  validates_length_of :first_name, :maximum=>20
  validates_length_of :last_name, :maximum=>20

  validates_inclusion_of :gender, :in => %w( male female ), :message => 'You must select a gender.'

  validates_uniqueness_of :email

  # Custom Methods
  
  #def gender(possessive=false)
  #  if possessive
  #    if self.gender == "male"
  #     "his"
  #    else
  #     "her"
  #    end
  #  else
  #    self.gender
 #  end
 # end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  def verify!
    self.verified = true
    self.save
  end

  def name
    self.first_name + " " + self.last_name + " - " + self.email
  end

  def title
    first_name.capitalize + " " + last_name.capitalize
  end
  
  def parent_assessment_takes
    assessments = assessment_takes
    assessment_takes.each do |assessment|
      assessments -= assessment.feedback_takes
    end
    assessments 
  end
  
  def available_assessments
    assessments = Assessment.find(:all,:conditions => ["completed = ?",true])
    assessment_takes.each do |assessment_take|
      assessments -= [assessment_take.assessment]
    end
    assessments
  end

  # LAUNCH Points

  # Get the user's balance object
  # If group is provided, get the user's group balance object.
  def points(group = nil)
    group_id = (group.nil?)? nil : group.id
    balance = Balance.find_or_create_by_user_id_and_group_id(self.id, group_id)
    balance
  end

  # Invitations
  # TODO: Check error checking
  def accept_invitations_by_id(invitation_ids)
    invitation_ids.each do |invitation_id|
      invitation = Invitation.find(invitation_id)
      membership = Membership.new
      membership.user = self
      membership.group = invitation.group
      membership.role = Role.find_by_name('Student')

      invitation.status = 'Accepted'

      if !(membership.save && invitation.save)
        errors.add_to_base("Adding to groups failed")
      end
    end
  end

  def active_group
    if active_membership
      self.active_membership.group
    else
      nil
    end
  end

  def is_admin?
    if self.role == "Admin"
      true
    else
      false
    end
  end

private

  def set_role
    self.role ||= "User"
  end

end