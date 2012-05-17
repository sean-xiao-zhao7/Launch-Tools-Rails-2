class Answer < ActiveRecord::Base
  belongs_to :assessment_take
  belongs_to :question

  validates_presence_of :assessment_take_id  , :question_id
  
  def completed?
    !(value.nil? and text.nil?)
  end
  
  def num()
    if !self.value.nil?
      s = self.clone
      c = 0
      while s.value > 0
        if s.get(0)
          c+=1
        end
        s.value = s.value>>1
      end
      return c
    end
    return 0
  end

  def get(num)
    if not self.nil?
      if not self.value.nil?
        v = (self.value >> num)%2
        if v > 0
          return true
        else
          return false
        end
      else
        return false
      end
    else
      return false
    end
  end

  def set(num)
    is_set = self.get(num)
    if self.value.nil?
      self.value = 0
    end
    if is_set
      return true
    else
      self.value = self.value + (2**num)
      return true
    end
  end

  def clr(num)
    is_set = self.get(num)
    if self.value
    else
      self.value = 0
    end
    if is_set >0
      self.value = self.value - (2**num)
      return true
    else
      return false
    end
  end

  def question_content
    if assessment_take.is_feedback?
      question.feedback_content.personalize(assessment_take.user.first_name, assessment_take.user.gender)
    else
      question.content
    end
  end
end
