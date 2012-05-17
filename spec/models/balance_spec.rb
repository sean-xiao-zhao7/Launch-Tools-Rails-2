require 'spec_helper'

describe Balance do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :group_id => 1,
      :balance => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Balance.create!(@valid_attributes)
  end
end
