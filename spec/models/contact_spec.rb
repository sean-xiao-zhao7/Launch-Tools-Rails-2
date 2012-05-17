require 'spec_helper'

describe Contact do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :email => "value for email"
    }
  end

  it "should create a new instance given valid attributes" do
    Contact.create!(@valid_attributes)
  end
end
