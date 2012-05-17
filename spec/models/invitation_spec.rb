require 'spec_helper'

describe Invitation do
  before(:each) do
    @valid_attributes = {
      :sender_id => 1,
      :group_id => 1,
      :token => "value for token",
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :email => "value for email",
      :status => "value for status"
    }
  end

  it "should create a new instance given valid attributes" do
    Invitation.create!(@valid_attributes)
  end
end
