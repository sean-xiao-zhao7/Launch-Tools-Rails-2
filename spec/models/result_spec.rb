require 'spec_helper'

describe Result do
  before(:each) do
    @valid_attributes = {
      :result_type_id => 1,
      :assessment_id => 1,
      :is_feedback => false
    }
  end

  it "should create a new instance given valid attributes" do
    Result.create!(@valid_attributes)
  end
end
