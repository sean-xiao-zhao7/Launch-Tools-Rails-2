class AssessmentToken < ActiveRecord::Base
  belongs_to :user
  belongs_to :assessment
  belongs_to :group
  belongs_to :giver,
             :class_name => "User",
             :foreign_key => "giver_id"

  validates_presence_of :assessment_id, :user_id
end
