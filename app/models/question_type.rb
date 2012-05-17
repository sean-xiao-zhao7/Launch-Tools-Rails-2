class QuestionType < ActiveRecord::Base
  validates_presence_of :name
  has_many :questions
end
