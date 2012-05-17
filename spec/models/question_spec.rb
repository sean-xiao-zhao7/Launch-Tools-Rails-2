require 'spec_helper'

describe Question do
  before(:each) do
    @valid_attributes = {
      :question_type_id => ,
      :question => ,
      :assessment_id => ,
      :category_id => ,
      :parent_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Question.create!(@valid_attributes)
  end
end
