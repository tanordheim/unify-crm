@api, @api_v1, @rack_test
Feature: Show user via API v1
  As an API client
  In order to do things with users
  I want to retrieve information about a user

  Scenario: Retrieve user information
    Given I have a Unify instance
    And I have an API application key
    And I have 1 additional user
    And I accept API version 1
    When I send an API request for that user
    Then the response code should be 200
    And the JSON response should be a "user" object

  Scenario: Retrieve user information for a non-existant user
    Given I have a Unify instance
    And I have an API application key
    And I accept API version 1
    When I send an API request to "/users/nonexistant"
    Then the response code should be 404

  Scenario: Retrieve user information without being authenticated
    Given I have a Unify instance
    And I have 1 additional user
    And I accept API version 1
    When I send an API request for that user
    Then the response code should be 401

  Scenario: Retrieve user information for a non-existant user without being authenticated
    Given I have a Unify instance
    Given I accept API version 1
    When I send an API request to "/users/nonexistant"
    Then the response code should be 401
