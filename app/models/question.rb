class Question < ActiveRecord::Base

  belongs_to :assessment
  belongs_to :category
  belongs_to :question_type
  has_many :answers,  :dependent => :destroy
  has_many :McOptions,  :dependent => :destroy

  acts_as_list :scope => :assessment

  validates_presence_of :content
  validates_presence_of :assessment_id
  validates_presence_of :question_type_id

end
