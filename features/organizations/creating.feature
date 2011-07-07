Feature: Creating Organizations
  As a user of the system
  In order to expand the organization base
  I want to add a new organization

  Scenario: Adding organization
    Given I am logged in as a user
    When I go to the contacts page
    And I click the "Add a new organization" content action
    And I fill in "Name" with "Test Organization"
    And I submit the form
    Then I should be on the page for that organization
    And I should see the alert "The organization was successfully created"
    And I should see the "Test Organization" entity header
