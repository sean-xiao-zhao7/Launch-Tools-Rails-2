# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def reload_flash
    page.replace "flash_messages", :partial => 'layouts/flash'
  end

  def is_active?(page_name)
    "active" if @title == page_name
  end

  # From http://asciicasts.com/episodes/197-nested-model-form-part-2
  # To use in a form:
  # Create a partial with the association's fields called association_fields
  # Ex: contact_fields
  # Then add this link inside the form for the parent:
  # = link_to_add_fields "Invite More", f, :invitations
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  # Note: This is just to remove the fields - this does not mark them for deletion
  # Usage: = link_to_remove_fields "remove", f
  def link_to_remove_fields(name, f)
    link_to_function(name, "remove_fields(this)")
  end

end

class String

  # Summarizes the string to the given wordcount and adds ... if there's more.
  def summarize(wordcount)
    self..split[0..(wordcount-1)].join(" ") +
      (self.split.size > wordcount ? "..." : "")
  end

  # Used to personalize questions
  # Takes a leader's name and a gender (in lowercase)
  # Changes 'This Leader' to the name passed in
  # Changes gender according to the gender passed in
  def personalize(leader_name, gender)
    result = self
    result.gsub!('This leader', leader_name)
    result.gsub!('this leader', leader_name)

    if gender == 'male'
      result.gsub!('He/She', 'He')
      result.gsub!('he/she', 'he')
      result.gsub!('Him/Her', 'Him')
      result.gsub!('him/her', 'him')
      result.gsub!('His/Her', 'His')
      result.gsub!('his/her', 'his')
    elsif gender == 'female'
      result.gsub!('He/She', 'She')
      result.gsub!('he/she', 'she')
      result.gsub!('Him/Her', 'Her')
      result.gsub!('him/her', 'her')
      result.gsub!('His/Her', 'Her')
      result.gsub!('his/her', 'her')
    end

    result
  end

end
