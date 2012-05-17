# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Make sure that the records don't already exist when creating them.
# We can use find_or_create or find_or_create_by_name to do this
# Look Under Dynamic attribute-based finders at http://api.rubyonrails.org/classes/ActiveRecord/Base.html

# Temporary Users
User.find_or_create_by_email("user@test.test", :first_name => "test", :last_name => "test", :verified=>true, :email => "user@test.test", :password => "test", :password_confirmation => "test", :birth_date => "1111/11/11", :gender => "male", :country => "Canada", :role => "User")
User.find_or_create_by_email("admin@test.test", :first_name => "test", :last_name => "test", :verified=>true, :email => "admin@test.test", :password => "test", :password_confirmation => "test", :birth_date => "1111/11/11", :gender => "male", :country => "Canada", :role => "Admin")
puts "Users seeded"

# Question Types
['Rate', 'Choose-one', 'Choose-many', 'Text'].each do |qt|
  QuestionType.find_or_create_by_name(qt)
end
puts "Question types seeded"

# Group Roles
['Owner','Head-Coach','Coach','Student'].each do |r|
  Role.find_or_create_by_name(r)
end
puts "Group Roles seeded"