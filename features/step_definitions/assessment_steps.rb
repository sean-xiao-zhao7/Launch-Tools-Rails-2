Given /^I have assessments titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Assessment.create!(:title => title)
  end
end
