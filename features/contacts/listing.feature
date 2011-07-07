Feature: Listing Contacts
  As a user of the system
  In order to get an overview over my contacts
  I want to see the list of contacts

  Background:
    Given I am logged in as a user
    And I have the organization "IBM"
    And I have the organization "Microsoft"
    And I have the organization "Apple"
    And I have the person "Bill Gates"
    And I have the person "Steve Jobs"
    And I have the person "Virginia M. Rometty"

  Scenario: List of contacts
    When I go to the contacts page
    Then I should see 3 organizations
    And I should see 3 people

  Scenario: Filtering to only show organizations
    When I go to the contacts page
    And I set the "type" filter to "Organizations"
    Then I should see 3 organizations
    And I should see 0 people

  Scenario: Filtering to only show people
    When I go to the contacts page
    And I set the "type" filter to "People"
    Then I should see 0 organizations
    And I should see 3 people
    
  Scenario: Searching contacts
    When I go to the contacts page
    And I enter "ro" for the "name" filter
    Then I should see 1 organization
    And I should see 1 person

  Scenario: Searching for contacts with filters present
    When I go to the contacts page
    And I set the "type" filter to "Organizations"
    And I enter "ro" for the "name" filter
    Then I should see 1 organization
    And I should see 0 people

  Scenario: Changing filter with search present
    When I go to the contacts page
    And I enter "ro" for the "name" filter
    And I set the "type" filter to "People"
    Then I should see 0 organization
    And I should see 1 person
