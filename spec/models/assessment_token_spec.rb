require 'spec_helper'

describe AssessmentToken do
  before(:each) do
    @valid_attributes = {
      :assessment_id => 1,
      :user_id => 1,
      :gift_email => "value for gift_email"
    }
  end

  it "should create a new instance given valid attributes" do
    AssessmentToken.create!(@valid_attributes)
  end
end
