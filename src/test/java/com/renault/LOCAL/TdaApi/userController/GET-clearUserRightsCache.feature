Feature: As a tda api client, I want to clear the user rights cache

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: To clear the user rights cache

    Given path '/api/v1/users/clear'
    When method get
    Then status 200
    And match response  ==  '#present'

