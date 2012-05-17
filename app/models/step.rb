class Step < ActiveRecord::Base
  belongs_to :goal
  belongs_to :contact

  has_many :checkins, :dependent => :destroy
  accepts_nested_attributes_for :checkins, :allow_destroy => true

  validates_presence_of :description, :reminder_checkin_date, :reminder_type, :start_date, :until_date, :reminder_freq
  
  def set_default_values
    self.reminder_checkin_date = self.get_due_date(self.reminder_type) if not self.once_type? and self.reminder_type != nil # For type Once the user picks the date, the other two are calculated
    if self.once_type?
      self.start_date = Date.today
      self.until_date = self.reminder_checkin_date
    elsif self.repeating?
      self.reminder_checkin_date = Date.today - 1 
    end
  end
    
  def accountable_to=(contact)
    self.update_attribute(:contact_id, contact.id)
  end
    
  def restart
    self.update_attribute(:completed, false)
  end
  
  def title
    if @title.nil? && !contact.nil?
      contact.title
    else 
      @title
    end
  end
  
  def title=(name)
    @title = name
  end
  
  def email
    contact.email unless contact.nil?
  end
  
  def email=(email)
    contact = Contact.find_by_email(email)
    if contact.nil?
      contact = Contact.new(:title => title, :email => email)
      contact.save
    end
    self.update_attribute(:contact_id, contact.id)
  end
  
  def reminder_times_target_weekly
    reminder_times_target
  end
  
  def reminder_times_target_monthly
    reminder_times_target
  end
  
  def reminder_times_target_weekly=(times)
    self.update_attribute(:reminder_times_target, times) if weekly_type?
  end
  
  def reminder_times_target_monthly=(times)
    self.update_attribute(:reminder_times_target, times) if monthly_type?
  end
  
  def completed?
    if completed
      "Yes"
    else
      "No"
    end
  end
  
  def accountability
    if (contact_id.nil? || contact_id.zero?)
      nil
    else
      if contact == nil
        "contact is nil, delete me!"
      else
        contact.title    
      end
    end
  end
  
  def delete_contact
    self.update_attribute(:contact_id, nil)    
  end
    
  ######################################
  # checkin functionalities down below #
  ######################################
  
  def once_type?
    return true if reminder_type == "Once"
    return false
  end
  
  def weekly_type?
    return true if reminder_freq == 1
    return false
  end
  
  def monthly_type?
    return true if reminder_freq == 0
    return false
  end
  
  def repeating?
    return true if reminder_type == "Repeating"
    return false
  end
  
  def checkin_date
    if completed || reminder_checkin_date.nil?
      nil
    else
      reminder_checkin_date.strftime("%b %d, %Y")
    end
  end
  
  def span
    if once_type?
      "Due " + "#{until_date.strftime("%b %d, %Y")}" 
    else
      "#{start_date.strftime("%b %d, %Y")}" + " to " + "#{until_date.strftime("%b %d, %Y")}"
    end
  end
  
  def target
    if monthly_type?
      "Repeat " + reminder_times_target.to_s + " times per month"
    elsif weekly_type?
      "Repeat " + reminder_times_target.to_s + " times per week"
    elsif once_type?    
      "Due " + "#{until_date.strftime("%b %d, %Y")}"
    end
  end
    
  def days
    return "This Step is past due date" if late?
    if once_type?
      d = reminder_checkin_date - Date.today
    else
      d = get_due_date(reminder_freq) - Date.today
    end
    if d == 0
      return "Checkin today" if repeating?
      return "Due today"
    elsif d < 0
      d *= -1
      return "Next Checkin was " + d.to_s + " days ago" if repeating?
      return "Due " + d.to_s + " days ago"
    else
      return "Next Checkin is in " + d.to_s + " days" if repeating?
      return "Due in " + d.to_s + " days"
    end
  end
  
  def late?
    if once_type?    
      if reminder_checkin_date && completed ==false
        true if reminder_checkin_date < Date.today
      end
    else
      if (get_due_date(reminder_freq) - Date.today) < 0
        true
      end
    end  
  end
  
  def can_checkin?
    return false if start_date > Date.today
    
    if once_type?
      return true if until_date <= Date.today
    end
    
    return true if checkins.empty? || checkins.nil?
    return true unless previous_due_date == Date.today 
    # Okay, previous due date can be the starting date
    # We allow the user to checkin on the starting day; thus the second last "if"
    # disallow checkin more than once on the same day
  end
  
  # Given a type of reminder, compute the next due date
  def get_due_date(type)
    case type
      when 1 #week
        next_monday
      when 0 #monthly
        next_month_first
    end
  end
  
  def next_monday(date=Date.today)
    previous_week = date.cweek
    date = date.next() while ( date.cweek == previous_week )
    return date
  end
  
  def next_month_first(date=Date.today)
    month = date.month
    date = date.next() while ( date.month == month )
    return date
  end
    
  def previous_due_date
    if checkins.empty? || checkins.nil?
      return start_date
    else
      return last_checkin_date
    end
  end
  
  def last_checkin_date
    array = checkins.sort { |c1, c2| c1.until_date <=> c2.until_date }
    return array[-1].until_date
  end
  
  def scheduled_checkins
    array = Array.new
    # craete the missed checkins
    case reminder_freq
      when 1 # weekly
        # initiate checkins for all mondays between the last checkin and today
        date = self.previous_due_date.wday == 1 ? self.previous_due_date + 1 : self.previous_due_date
        end_date = Date.today
        while(date.cweek != end_date.cweek)
          ch = Checkin.new(:start_date => date, :until_date => date = next_monday(date), :step_id => id)
          #whatever attribute you set in "ch" is not saved when user clicks "create" unless you uses a "hidden_field" to send it along
          #could possibly do a "ch.save" right here to avoid the above situation 
          array << ch
        end
      when 0 # monthly
        # initiate checkins for all 1st of month between the last checkin and today
        date = self.previous_due_date.mday == 1 ? self.previous_due_date + 1 : self.previous_due_date
        end_date = Date.today
        while(date.month != end_date.month)
          ch = Checkin.new(:start_date => date, :until_date => date = next_month_first(date), :step_id => id)
          #whatever attribute you set in "ch" is not saved when user clicks "create" unless you uses a "hidden_field" to send it along
          #could possibly do a "ch.save" right here to avoid the above situation
          array << ch
        end
    end
    return array
  end
  
  def flatten_checkins(dict)
    dict.delete_if{ |k, v| v[:reminder_times_actual] == "" }
  end
  
  def set_next_due_date
    self.update_attribute(:reminder_checkin_date, get_due_date(reminder_type))
  end
  
  #Return an array in the format: ["date1", .... ]
  def get_checkin_dates    
    @format = Array.new
    checkins.each do |c|
      @format << c.reminder_checkin_date.strftime("%b %d")  
    end
    return @format
  end
  
  #Return an array in the format: "num1,num2,...,num"  
  def get_checkin_times(type)
    @format = Array.new
    checkins.each do |c|
      if type == "actual"
        @format << c.reminder_times_actual
      else
        @format << c.reminder_times_target
      end
    end
    return @format
  end

  def get_checkin_actuals
    return get_checkin_times("actual")    
  end
  
  def get_checkin_targets
    return get_checkin_times("target")    
  end
  
  # get the most target/actual, to set the graph's height
  def get_max_times
    max_actual = checkins.max {|a,b| a.reminder_times_actual <=> b.reminder_times_actual }
    max_target = checkins.max {|a,b| a.reminder_times_target <=> b.reminder_times_target }
    return [max_actual.reminder_times_actual, max_target.reminder_times_target].max
  end
end