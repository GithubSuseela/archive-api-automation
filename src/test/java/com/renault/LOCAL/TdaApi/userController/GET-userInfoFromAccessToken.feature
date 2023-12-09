@ignore
#Tested by TDPTF-1056
Feature: As a tda api client, I want to Get user information from the access_token

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: Get user information from the access_token

    Given path '/api/v1/users/me'
    When method get
    Then status 200
    And match response  ==  '#present'

