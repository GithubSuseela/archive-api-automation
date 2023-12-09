@verify-deployment
Feature: Info endpoint should return deployment information.

  Background:
    * url api_url

  Scenario: Deployment information should match the current pipeline.
    Given path 'info'
    When method get
    Then status 200
    And assert response.build.artifact == "tda-platform"
    And assert response.build.group == "com.renault.tda"