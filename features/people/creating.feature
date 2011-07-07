Feature: Creating Person
  As a user of the system
  In order to expand the contact person base
  I want to add a new person

  Scenario: Adding person
    Given I am logged in as a user
    When I go to the contacts page
    And I click the "Add a new person" content action
    And I fill in "First name" with "Test"
    And I fill in "Last name" with "Person"
    And I submit the form
    Then I should be on the page for that person
    And I should see the alert "The person was successfully created"
    And I should see the "Test Person" entity header
