require 'spec_helper'

describe Analysis do
  before(:each) do
    @valid_attributes = {
      :assessment_id => 1,
      :ShowIntro => false,
      :IntroText => "value for IntroText",
      :ShowBasicText => false,
      :BasicText => "value for BasicText",
      :ShowBasic_SelfText => false,
      :Basic_SelfText => "value for Basic_SelfText",
      :ShowBasic_FeedbackText => false,
      :Basic_FeedbackText => "value for Basic_FeedbackText",
      :Show_AdvancedText => false,
      :AdvancedText => "value for AdvancedText",
      :ShowAdvanced_SimilarText => false,
      :Advanced_SimilarText => "value for Advanced_SimilarText",
      :ShowAdvanced_EBSText => false,
      :Advanced_EBSText => "value for Advanced_EBSText",
      :ShowAdvanced_PBS => false,
      :Advanced_PBS => "value for Advanced_PBS",
      :ShowGrowthPlanText => false,
      :GrowthPlanText => "value for GrowthPlanText"
    }
  end

  it "should create a new instance given valid attributes" do
    Analysis.create!(@valid_attributes)
  end
end
