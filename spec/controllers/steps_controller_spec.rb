require 'spec_helper'

describe StepsController do

  #Delete these examples and add some real ones
  it "should use StepsController" do
    controller.should be_an_instance_of(StepsController)
  end


  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
end
