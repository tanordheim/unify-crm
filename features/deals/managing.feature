Feature: Managing Deals
  As a user of the system
  In order to keep the deal base up to date
  I want to manage a deal

  Background:
    Given I am logged in as a user
    And I have the deal "Test Deal" with the category "Printing" in stage "Negotiation"
    And I have the person "Test Person"
    And I have the organization "Test Organization"

  Scenario: Changing name
    When I go to the page for the deal
    And I set "name" to "Another Prospect" via inline editing
    Then I should see the "Another Prospect" entity header
    When I reload the page
    Then I should see the "Another Prospect" entity header

  Scenario: Changing pricing
    When I go to the page for the deal
    And I start changing the deal pricing
    And I fill in "deal_price" with "100"
    And I select "Fixed bid" from "deal_price_type"
    And I save the deal pricing
    Then I should see the deal price "100,00"
    When I reload the page
    Then I should see the deal price "100,00"

  Scenario: Changing stage
    Given I have the deal stage "Presentation"
    And I go to the page for the deal
    And I start changing the deal stage
    And I select "Presentation" from "deal_stage_id"
    And I save the deal stage
    Then I should see the stage "Presentation" for the deal
    When I reload the page
    Then I should see the stage "Presentation" for the deal

  Scenario: Changing category
    Given I have the deal category "Programming"
    And I go to the page for the deal
    And I start changing the deal category
    And I select "Programming" from "deal_category_id"
    And I save the deal category
    Then I should see the category "Programming" for the deal
    When I reload the page
    Then I should see the category "Programming" for the deal

  Scenario: Setting source
    Given I have the source "Test Source"
    When I go to the page for the deal
    Then I should see the source "No source set"
    When I select "Test Source" from "source_id" via inline editing
    Then I should see the source "Test Source"
    When I reload the page
    Then I should see the source "Test Source"

  Scenario: Listing comments
    Given I have 2 comments for the deal
    When I go to the page for the deal
    Then I should see 2 comments

  Scenario: Creating comments
    When I go to the page for the deal
    And I click the link "Add a comment"
    And I fill in "comment_body" with "Test Comment"
    And I submit the form
    Then I should see the alert "The comment was successfully created"
    And I should see 1 comment
