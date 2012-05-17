require 'spec_helper'

describe Assessment do
  before(:each) do
    @valid_attributes = {
      :title => "My New Assessment",
      :description => "This is my description of my assessment. Great huh?"
    }
  end

  it "should create a new instance given valid attributes" do
    Assessment.create!(@valid_attributes)
  end

  it "should require a title" do
    no_title = Assessment.new(@valid_attributes.merge(:title => ""))
    no_title.should_not be_valid
  end
end
