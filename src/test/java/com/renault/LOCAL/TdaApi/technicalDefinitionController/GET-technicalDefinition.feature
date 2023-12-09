Feature: As a tda api client, I want to find a Technical Definition by technical definition code

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  GET - 200 find a Technical Definition details by technical definition code

    Given path '/api/v1/technical-definitions/details'
    And param code = 3
    When method get
    Then status 200
    And match response  ==  '#present'