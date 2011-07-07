Feature: Creating Deals
  As a user of the system
  In order to register new prospective projects
  I want to add a new deal

  Scenario: Adding deal
    Given I am logged in as a user
    And I have the organization "Test Organization"
    And I have the deal stage "Lost" with the percentage 0
    And I have the deal stage "Negotiation" with the percentage 10
    When I go to the deals page
    And I click the "Add a new deal" content action
    And I fill in "Name" with "Test Deal"
    And I type "test" in "organization_id_label" and select "Test Organization" from autocomplete results
    And I submit the form
    Then I should be on the page for that deal
    And I should see the alert "The deal was successfully created"
    And I should see the "Test Deal" entity header
