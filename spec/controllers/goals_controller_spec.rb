require 'spec_helper'

describe GoalsController do
  integrate_views

  # TEST the index function
  describe "GET 'index'" do

    it "should be successful when their are no goals" do
      get :index
      response.should be_success
    end

  end

  #TEST the Create function
  describe "GET 'new'" do
    before(:each) do
      @goal = Factory(:goal)
      Goal.stub!(:find, @goal.id).and_return(@goal)
    end

    it "can make new goals" do
      get :new
      response.should be_success
    end
  end

  #TEST the edit function
  describe "GET 'edit'" do
    before(:each) do
      @goal = Factory(:goal)
      Goal.stub!(:find, @goal.id).and_return(@goal)
    end

    it "should be successful" do
      get :edit, :id => @goal
      response.should be_success
    end
  end

  #TEST the Delete function
  describe "GET 'new'" do
    before(:each) do
      @attr = { :description => "New User", :target => "Others",
              :completed => false }
      @goal = Factory(:goal, @attr)
      Goal.stub!(:find, @goal.id).and_return(@goal)
    end

    it "can make new goals" do
      get :new
      response.should be_success
    end
  end

end
