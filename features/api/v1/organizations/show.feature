@api, @api_v1, @rack_test
Feature: Show organization via API v1
  As an API client
  In order to do things with organizations
  I want to retrieve information about an organization

  Scenario: Retrieve organization information
    Given I have a Unify instance
    And I have an API application key
    And I have 1 organization
    And I accept API version 1
    When I send an API request for that organization
    Then the response code should be 200
    And the JSON response should be an "organization" object

  Scenario: Retrieve organization information for a non-existant organization
    Given I have a Unify instance
    And I have an API application key
    And I accept API version 1
    When I send an API request to "/organizations/nonexistant"
    Then the response code should be 404

  Scenario: Retrieve user information without being authenticated
    Given I have a Unify instance
    And I have 1 organization
    And I accept API version 1
    When I send an API request for that organization
    Then the response code should be 401

  Scenario: Retrieve organization information for a non-existant organization without being authenticated
    Given I have a Unify instance
    Given I accept API version 1
    When I send an API request to "/organizations/nonexistant"
    Then the response code should be 401
