Feature: Listing deals
  As a user of the system
  In order to see upcoming projects for my organization
  I want to be able to list deals

  Background:
    Given I am logged in as a user
    And I have the deal "Super Deal 1" with the category "Category 1" in stage "Presentation"
    And I have the deal "Awesome Deal 2" with the category "Category 1" in stage "Negotiation"
    And I have the deal "Poor Deal 3" with the category "Category 2" in stage "Presentation"
  
  Scenario: List of deals
    When I go to the deals page
    Then I should see 3 deals

  Scenario: Filtering to only show a specific category
    When I go to the deals page
    And I set the "category" filter to "Category 1"
    Then I should see 2 deals

  Scenario: Filtering to only show a specific stage
    When I go to the deals page
    And I set the "stage" filter to "Presentation"
    Then I should see 2 deals
  
  Scenario: Searching deals
    When I go to the deals page
    And I enter "awesome" for the "keywords" filter
    Then I should see 1 deal
