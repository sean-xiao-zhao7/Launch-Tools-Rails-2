class UserMailer < ActionMailer::Base
  def registration_confirmation(user, current_user)
    recipients user.email
    from  "Launch Tools"
    subject "A Launch Tools account has been created for you"
    body :user => user, :current_user => current_user
  end

  def password_update(user)
    recipients user.email
    from  "Launch Tools"
    subject "Your Password has Been changed"
    body :user => user
  end

  def account_update(user, old_email)
    recipients user.email
    bcc old_email
    from  "Launch Tools"
    subject "Your Account has been Updated"
    body :user => user
  end

  def verification_instructions(user)
    subject       "Email Verification"
    from          "Launch Tools"
    recipients    user.email
    sent_on       Time.now
    body          :verification_url => user_verification_url(user.perishable_token)
  end

  def password_reset_instructions(user)
    subject      "Password Reset Instructions"
    from         "Launch Tools"
    recipients   user.email
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def feedback_email(contact, feedback_take, user)
    subject      "Feedback Email"
    from         "Launch Tools"
    recipients   contact.email
    sent_on      Time.now
    body         :feedback_link_url => fbtake_welcome_url(feedback_take.token),:contact => contact, :user =>user, :assessment_name => feedback_take.assessment.title
  end

  def account_destroyed(user)
    subject      "Your account has been destroyed!!!!"
    from         "Launch Tools"
    recipients   user.email
    sent_on      Time.now
    body         :user => user
  end

  def send_user_email(email, subject, text, current_user)
    subject      subject
    from         "Launch Tools"
    recipients   email
    sent_on      Time.now
    body         :sender => current_user, :text => text
  end

  def invite_existing_user(user, group)
    subject      "You've been invited to the #{group.name} Group"
    from         "Launch Tools"
    recipients   user.email
    sent_on      Time.now
    body         :user => user, :group => group
  end

  def invite_new_user(invitation, group)
    subject      "You've been invited to the #{group.name} LAUNCH Tools Site"
    from         "Launch Tools"
    recipients   invitation.email
    sent_on      Time.now
    body         :invitation => invitation, :group => group, :sign_up_link => invite_new_user_url(:invitation_token => invitation.token)
  end
  
  def send_accountability_confirmation(user, step, contact)
    subject      "LAUNCH Tools - Growth Plan Accountability Partner Invitation."
    from         "Launch Tools"
    recipients   contact.email
    sent_on      Time.now
    body         "#{user.title} have invited you to become #{user.gender(true)} accountability  partner for one of #{user.gender(true)} steps in the Growth Plan, on the LAUNCH Tools Site. \nYou may choose to accept or decline #{user.gender(true)} request."
  end
end