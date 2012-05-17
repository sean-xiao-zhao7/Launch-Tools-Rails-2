class Result < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :result_type

  validates_presence_of :result_type_id, :assessment_id

end
