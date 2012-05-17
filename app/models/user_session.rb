class UserSession < Authlogic::Session::Base
  validate :check_if_verified

  private

  def check_if_verified

    errors.add(:base, "Your account has not been verified") unless attempted_record && attempted_record.verified

  end
end