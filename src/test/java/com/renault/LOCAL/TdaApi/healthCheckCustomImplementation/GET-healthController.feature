@ignore
#Tested by TDPTF-1014
Feature: As a tda api client, I want to fetch the health check

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Health Check
    Given path '/ping'
    When method get
    Then status 200
    And match response == '#present'
