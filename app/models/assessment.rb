class Assessment < ActiveRecord::Base
  attr_accessible :title, :description, :completed, :pagination

  validates_presence_of :title
  validates_presence_of :pagination


  has_many :questions, :dependent => :destroy, :order => "position"
  has_many :categories, :dependent => :destroy
  has_many :assessment_takes, :dependent => :destroy
  has_many :results, :dependent => :destroy
  has_one  :instruction,
           :class_name => "AtInstruction",
           :foreign_key => "assessment_id",
           :dependent => :destroy
  has_one :analysis, :dependent => :destroy
  has_many :transactions
  has_many :assessment_tokens

  #Gives a the description limited to 20 words
  def short_description
    wordcount = 13

    description.split[0..(wordcount-1)].join(" ") +
      (description.split.size > wordcount ? "..." : "")
  end

  #Returns all the child categories available in this assessment
  def child_categories
    children = Array.new
    categories.each do |category|
      children << category if !category.has_child?
    end
    children
  end

  #Returns all the parent categories available in this assessment
  def parent_categories
      parents = Array.new
      categories.each do |category|
        parents << category if !(category.has_parent?)
      end
      parents
  end

  #Returns the question type that is used in this assessment
  def question_type
    questions[0].question_type.name
  end

  # Returns the assessment take created if successful
  # Returns -1 if unsuccessful
  def make_assessment_take(user, parent = nil, contact = nil)
    at = AssessmentTake.new
    at.assessment_id = self.id
    at.user_id = user.id
    at.contact_id = contact.id if !(contact.nil?)
    at.parent_id = parent.id if !(parent.nil?)
    at.is_completed = false

    if at.save
      success = true

      at.assessment.questions.each do |q|
        if q.question_type.name == "Rate" or q.question_type.name == "Text" or q.question_type.name == "Choose-one" or q.question_type.name == "Choose-many"
          answer = Answer.new

          answer.assessment_take_id = at.id
          answer.question_id = q.id
          # TODO: Need to do something if answer doesn't get saved.
          success = false if !(answer.save)
        else # other question types go here
        end
      end # if at.save

    else # Assessment Take Creation failed
      success = false
      at.destroy
    end

    if success
      at
    else
      -1
    end
  end

end
