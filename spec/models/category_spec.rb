require 'spec_helper'

describe Category do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :assessment_id => 1,
      :parent_id => 1,
      :prev_id => 1,
      :next_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Category.create!(@valid_attributes)
  end
end
