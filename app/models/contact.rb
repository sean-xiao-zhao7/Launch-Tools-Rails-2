class Contact < ActiveRecord::Base
  belongs_to :users
  has_many :steps
  has_many :assessment_takes, :dependent => :destroy
  accepts_nested_attributes_for :assessment_takes
  #validate :cannot_add_self

  validates_uniqueness_of :email, :scope => :user_id

  validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :message => "must be a valid email address"

  def title
    [first_name, last_name].join(' ')
  end
  
  def title=(name)
    names = name.split(' ')
    self.first_name = names.first
    if names.first != names.last
      self.last_name = names.last
    end
  end

  def info
    modded_email = '<' + email + '>'
    [first_name, last_name, modded_email].join(' ')
  end
  
  private
    def cannot_add_self
      errors.add_to_base("You cannot add yourself as a contact") if (self.user.email == email)
    end
end