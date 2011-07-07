@api, @api_v1, @rack_test
Feature: List organizations via API v1
  As an API client
  In order to do things with organizations
  I want to retrieve a list of organizations

  Scenario: Retrieve organization list
    Given I have a Unify instance
    And I have an API application key
    And I have 3 organizations
    And I accept API version 1
    When I send an API request to "/organizations"
    Then the response code should be 200
    And the JSON response should be a "organizations" array with 3 elements

  Scenario: Retrieve organization list without being authenticated
    Given I have a Unify instance
    Given I accept API version 1
    When I send an API request to "/organizations"
    Then the response code should be 401
