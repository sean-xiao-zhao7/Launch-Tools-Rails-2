class Balance < ActiveRecord::Base
  # Note: user.points returns the balance object
  # user.points(group) returns the user's balance object for that group

  belongs_to :user
  belongs_to :group

  validates_presence_of :user_id

  # Add/Deduct methods
  # Return true if successful
  # Return false on failure

  def add(amount)
    self.balance += amount
    return self.save
  end

  def deduct(amount)
    if self.balance < amount
      return false
    else
      self.balance -= amount
      return self.save
    end    
  end

  private

    def initialize
      super
      self.balance = 0
    end

end
