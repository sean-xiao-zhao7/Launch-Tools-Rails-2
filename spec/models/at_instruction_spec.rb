require 'spec_helper'

describe ATInstructions do
  before(:each) do
    @valid_attributes = {
      :assessment_id => 1,
      :intro => "value for intro",
      :pre_take => "value for pre_take",
      :fb_welcome => "value for fb_welcome",
      :fb_save => "value for fb_save",
      :fb_submit => "value for fb_submit"
    }
  end

  it "should create a new instance given valid attributes" do
    ATInstructions.create!(@valid_attributes)
  end
end
