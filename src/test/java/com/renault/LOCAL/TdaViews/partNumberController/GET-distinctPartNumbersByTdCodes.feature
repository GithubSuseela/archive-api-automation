Feature: As a tda api client, I want to find distinct part numbers by technical definition codes

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario: GET - 200 - Find distinct part numbers by technical definition codes

    * def tdCode = 3
    Given path '/api/v1/part-numbers'
    And param technicalDefinitionCodes = tdCode
    When method get
    Then status 200
    And match response  ==  '#present'