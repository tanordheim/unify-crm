Feature: Managing Organizations
  As a user of the system
  In order to keep the contact organization base up to date
  I want to manage an organization

  Background:
    Given I am logged in as a user
    And I have the organization "Test Organization"
    And I have the person "Test Person"

  Scenario: Changing name
    When I go to the page for the organization
    And I set "name" to "Another Company" via inline editing
    Then I should see the "Another Company" entity header
    When I reload the page
    Then I should see the "Another Company" entity header

  Scenario: Changing background information
    When I go to the page for the organization
    And I set "background" to "Test Background Information" via inline editing
    Then I should see the background information "Test Background Information"
    When I reload the page
    Then I should see the background information "Test Background Information"

  Scenario: Adding employee
    When I go to the page for the organization
    Then I should see 0 employees
    When I click the link "Add an employee"
    And I fill in "employment_title" with "CEO"
    And I type "test" in "person_label" and select "Test Person" from autocomplete results
    And I save the employee
    Then I should see 1 employee
    When I reload the page
    Then I should see 1 employee

  Scenario: Removing employee
    Given I have 1 employee for the organization
    When I go to the page for the organization
    Then I should see 1 employee
    When I delete the first employee
    Then I should see 0 employees
    When I reload the page
    Then I should see 0 employees

  Scenario: Adding address
    When I go to the page for the organization
    Then I should see 0 addresses
    When I click the link "Add an address"
    And I fill in "address_street_name" with "Test Street Name"
    And I save the address
    Then I should see 1 addresses
    When I reload the page
    Then I should see 1 addresses

  Scenario: Removing address
    Given I have 1 address for the organization
    When I go to the page for the organization
    Then I should see 1 address
    When I delete the first address
    Then I should see 0 addresses
    When I reload the page
    Then I should see 0 addresses

  Scenario: Adding phone number
    When I go to the page for the organization
    Then I should see 0 phone numbers
    When I click the link "Add a phone number"
    And I fill in "phone_number_number" with "12345678"
    And I save the phone number
    Then I should see 1 phone number
    When I reload the page
    Then I should see 1 phone number

  Scenario: Removing phone number
    Given I have 1 phone number for the organization
    When I go to the page for the organization
    Then I should see 1 phone number
    When I delete the first phone number
    Then I should see 0 phone numbers
    When I reload the page
    Then I should see 0 phone numbers

  Scenario: Adding website
    When I go to the page for the organization
    Then I should see 0 websites
    When I click the link "Add a website"
    And I fill in "website_url" with "http://example.com"
    And I save the website
    Then I should see 1 website
    When I reload the page
    Then I should see 1 website

  Scenario: Removing website
    Given I have 1 website for the organization
    When I go to the page for the organization
    Then I should see 1 website
    When I delete the first website
    Then I should see 0 website
    When I reload the page
    Then I should see 0 website

  Scenario: Adding instant messenger
    When I go to the page for the organization
    Then I should see 0 instant messengers
    When I click the link "Add an instant messenger"
    And I fill in "instant_messenger_handle" with "test"
    And I save the instant messenger
    Then I should see 1 instant messenger
    When I reload the page
    Then I should see 1 instant messenger

  Scenario: Removing instant messenger
    Given I have 1 instant messenger for the organization
    When I go to the page for the organization
    Then I should see 1 instant messenger
    When I delete the first instant messenger
    Then I should see 0 instant messengers
    When I reload the page
    Then I should see 0 instant messengers

  Scenario: Adding e-mail address
    When I go to the page for the organization
    Then I should see 0 e-mail address
    When I click the link "Add an e-mail address"
    And I fill in "email_address_address" with "test@test.com"
    And I save the e-mail address
    Then I should see 1 e-mail address
    When I reload the page
    Then I should see 1 e-mail address

  Scenario: Removing e-mail address
    Given I have 1 e-mail addresses for the organization
    When I go to the page for the organization
    Then I should see 1 e-mail address
    When I delete the first e-mail address
    Then I should see 0 e-mail addresses
    When I reload the page
    Then I should see 0 e-mail addresses

  Scenario: Adding twitter account
    When I go to the page for the organization
    Then I should see 0 twitter accounts
    When I click the link "Add a twitter account"
    And I fill in "twitter_account_username" with "test"
    And I save the twitter account
    Then I should see 1 twitter account
    When I reload the page
    Then I should see 1 twitter account

  Scenario: Removing twitter account
    Given I have 1 twitter account for the organization
    When I go to the page for the organization
    Then I should see 1 twitter account
    When I delete the first twitter account
    Then I should see 0 twitter accounts
    When I reload the page
    Then I should see 0 twitter accounts

  Scenario: Setting source
    Given I have the source "Test Source"
    When I go to the page for the organization
    Then I should see the source "No source set"
    When I select "Test Source" from "source_id" via inline editing
    Then I should see the source "Test Source"
    When I reload the page
    Then I should see the source "Test Source"

  Scenario: Listing comments
    Given I have 2 comments for the organization
    When I go to the page for the organization
    Then I should see 2 comments

  Scenario: Creating comments
    When I go to the page for the organization
    And I click the link "Add a comment"
    And I fill in "comment_body" with "Test Comment"
    And I submit the form
    Then I should see the alert "The comment was successfully created"
    And I should see 1 comment
