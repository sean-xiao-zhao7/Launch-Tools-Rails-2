require 'spec_helper'

describe QuestionTypeController do

  #Delete these examples and add some real ones
  it "should use QuestionTypeController" do
    controller.should be_an_instance_of(QuestionTypeController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'add'" do
    it "should be successful" do
      get 'add'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'delete'" do
    it "should be successful" do
      get 'delete'
      response.should be_success
    end
  end
end
