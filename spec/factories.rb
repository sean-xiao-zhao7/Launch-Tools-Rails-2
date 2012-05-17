# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :goal do |goal|
  goal.description  "The Test Goal"
  goal.target        "Others"
  goal.completed    false
end