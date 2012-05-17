Feature: Manage Assessments
  Scenario: A User creates a new assessment with a title and a description
    Given I have assessments titled My Assessment, My Other Assessment
    When I go to the list of assessments
    Then I should see "My Assessment"
    And I should see "My Other Assessment"