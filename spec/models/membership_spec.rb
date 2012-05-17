require 'spec_helper'

describe Membership do
  before(:each) do
    @valid_attributes = {
      :group_id => 1,
      :user_id => 1,
      :role_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Membership.create!(@valid_attributes)
  end
end
