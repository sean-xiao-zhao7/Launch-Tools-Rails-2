require 'spec_helper'

describe Step do
  before(:each) do
    @valid_attributes = {
      :description => "value for description",
      :due_date => Time.now,
      :accountable_to => "value for accountable_to"
    }
    @step = Step.create!(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    #step
  end

  it "should require a description" do
    no_d_step = Step.new(@valid_attributes.merge(:description => ""))
    no_d_step.should_not be_valid
  end

  it "should require a target" do
    no_d_step = Step.new(@valid_attributes.merge(:due_date => ""))
    no_d_step.should_not be_valid
  end

  it "should require a 'accountable to' field" do
    no_d_step = Step.new(@valid_attributes.merge(:accountable_to => ""))
    no_d_step.should_not be_valid
  end

   it "should reject duplicate descriptions" do
    step_with_duplicate_email = Step.new(@valid_attributes)
    step_with_duplicate_email.should_not be_valid
  end

  it "should reject description identical up to case" do
    upcased_description = @valid_attributes[:description].upcase
    Step.create!(@valid_attributes.merge(:description => upcased_description))
    step_with_duplicate_description = Step.new(@valid_attributes)
    step_with_duplicate_description.should_not be_valid
  end

end
