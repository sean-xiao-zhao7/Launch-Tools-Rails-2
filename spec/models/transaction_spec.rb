require 'spec_helper'

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :group_id => 1,
      :gift_email => "value for gift_email",
      :points => 1,
      :cost => 1,
      :token => "value for token",
      :transaction_id => "value for transaction_id",
      :params => "value for params",
      :status => "value for status"
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
end
