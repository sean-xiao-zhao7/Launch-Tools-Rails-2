require 'spec_helper'

describe Goal do
  before(:each) do
    @valid_attributes = {
      :description => "value for description",
      :target => "value for target",
      :completed => false
    }
    @goal = Goal.create!(@valid_attributes)
  end

  it "should require a description" do
    no_d_goal = Goal.new(@valid_attributes.merge(:description => ""))
    no_d_goal.should_not be_valid
  end

  it "should require a target" do
    no_d_goal = Goal.new(@valid_attributes.merge(:target => ""))
    no_d_goal.should_not be_valid
  end

  it "should not be completed" do
    no_d_goal = Goal.new(@valid_attributes)
    no_d_goal.completed? == "no"
  end

  it "should return 'yes' if completed, 'no' otherwise" do
    comp_goal = Goal.new(@valid_attributes.merge(:completed => true))
    comp_goal.completed? == "yes"
    comp_goal.completed = false
    comp_goal.completed? == "no"
  end

  it "should reject duplicate descriptions" do
    goal_with_duplicate_email = Goal.new(@valid_attributes)
    goal_with_duplicate_email.should_not be_valid
  end

  it "should reject description identical up to case" do
    upcased_description = @valid_attributes[:description].upcase
    Goal.create!(@valid_attributes.merge(:description => upcased_description))
    goal_with_duplicate_description = Goal.new(@valid_attributes)
    goal_with_duplicate_description.should_not be_valid
  end
end
