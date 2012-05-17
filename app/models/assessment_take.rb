class AssessmentTake < ActiveRecord::Base
  #belongs_to :user
  belongs_to :contact
  validates_uniqueness_of :contact_id, :scope => :parent_id, :allow_nil => true, :message => 'You cannot add a feedback member twice.'
  belongs_to :user
  has_many :answers,  :dependent => :destroy
  accepts_nested_attributes_for :answers, :allow_destroy => true
  belongs_to :assessment

  # Generate a Token for the assessment take
  # Found in lib/token_generator.rb
  # Source/Documentation: http://github.com/rails/token_generator
  include TokenGenerator
  # Note: Currently tokens are unique per assessment_take
  before_create :set_token

  # Feedback Linkage
  belongs_to  :parent,
              :class_name => "AssessmentTake",
              :foreign_key => "parent_id"

  has_many    :feedback_takes,
              :class_name => "AssessmentTake",
              :foreign_key => "parent_id",
              :dependent => :destroy

  #TODO: Add user_id here once available
  validates_presence_of :assessment_id, :user_id

  # Get a collection of all feedback emails
  def get_feedback_emails
    feedback_emails = feedback_takes.collect{ |f| f.contact.email }
  end
  
  def completed_questions
    total_answered = 0
    answers.each do |answer|
      total_answered += 1 if answer.completed?
    end
    total_answered
  end
  
  def started?
    completed_questions == 0 ? false : true
  end
  
  def completed?   #if all questions have been answered
    if completed_questions == answers.length
      true
    else
      false
    end
  end
  
  def progress
    if completed? 
      if is_feedback?
        "Feedback Completed"
      else
        "Self Assessment Completed"
      end
    else
      "#{completed_questions} of #{answers.length} Completed"
    end
  end
  
  def percentage_completed
    if completed_questions == 0
      0
    else
      ((completed_questions.to_f / answers.length.to_f) * 100).to_i
    end
  end

  # If this assessment take has a valid contact, then it is a feedback assessment
  def is_feedback?
    if self.contact
      true
    else
      false
    end
  end
  
#   def number_of_pages   #not in sync with pagination.... should be updated?
#     number_of_questions = assessment.questions.length
#     pages = number_of_questions / Question.per_page
#     pages += 1 if number_of_questions % Question.per_page
#   end

  private

    # Ensure the tokens are unique per assessment_take
    # Currently we want tokens to be unique to the entire assessments model.
#    def set_token
#      self.token = generate_token { |token| self.class.find_by_parent_id_and_token(id,self.token).nil? }
#    end

end
