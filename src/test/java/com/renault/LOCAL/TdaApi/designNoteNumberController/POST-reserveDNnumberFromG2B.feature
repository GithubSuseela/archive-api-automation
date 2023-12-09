#@ignore
#Tested by TDPTF-978
Feature: As a tda client, I want to reserve a design note number from G2B

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 200 - Reserve a design note number from G2B

    Given path '/api/v1/g2b/design-note-numbers'
    And request ''
    When method post
    Then status 200
    And match response == '#present'
