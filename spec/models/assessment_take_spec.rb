require 'spec_helper'

describe AssessmentTake do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :assessment_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    AssessmentTake.create!(@valid_attributes)
  end
end
