class Goal < ActiveRecord::Base

  belongs_to  :user
  has_many :steps, :dependent => :destroy
  
  before_update :check_target_change
  acts_as_list :scope => :user
  
  has_attached_file :reward, :default_url => "/images/rewards/missing.png", :url => "/images/rewards/:basename.:extension"
  validates_attachment_size :reward, :less_than => 500.kilobytes#, :unless => Proc.new {|goal| goal[:reward].nil?}
  validates_attachment_content_type :reward, :content_type => /image/, :message => "must be an image"#, :unless => Proc.new {|goal| goal[:reward].nil?}
  
  validates_presence_of :description

  def current_steps
    @temp = steps - steps.find(:all, :conditions => { :completed => true })
    #@temp.sort! { |x, y| x.reminder_checkin_date <=> y.reminder_checkin_date } unless @temp == []  
    return @temp
  end
  
  def completed_steps
    steps.find(:all, :conditions => { :completed => true })
  end
  
  def restart_steps
    unless steps == []  
      steps.all.each do |step|
        step.restart
      end
    end
  end
  
  def has_reward?
    reward.url == "/images/rewards/missing.png" ? false : true
  end
  
  def complete
    self.update_attribute(:completed, true)
  end
  
  def completed?
    if completed
      "Yes"
    else
      "No"
    end
  end
  
  def all_steps_completed?
    self.steps.all.each do |step|
      return false if step.completed == nil || step.completed == false      
    end   
    if self.steps == [] || self.completed
      return false
    else
      return true
    end
  end
  
  def has_target?
    if target.nil? || target == "Select a Target"
      return false
    end
    return true
  end
  
  def has_category?
    if category.nil? || category == "Select a Category"
      return false
    end
    return true
  end
  
  def categories
    if has_target?
      return Assessment.find_by_title(target).child_categories
    end
    return false
  end

private

  def check_target_change
    unless target == Goal.find(self).target
      self.category = "Select a Category"
    end
  end

end