class Analysis < ActiveRecord::Base
  belongs_to :assessment

  validates_presence_of :assessment_id
end
