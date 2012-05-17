class McOption < ActiveRecord::Base
  belongs_to :question
  belongs_to :category

  validates_presence_of :question_id
  validates_presence_of :content
end
