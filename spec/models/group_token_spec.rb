require 'spec_helper'

describe GroupToken do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :tokens => 1,
      :owner_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    GroupToken.create!(@valid_attributes)
  end
end
