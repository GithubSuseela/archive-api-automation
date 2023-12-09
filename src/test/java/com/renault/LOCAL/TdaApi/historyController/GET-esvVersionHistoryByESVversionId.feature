@ignore
#Tested by TDPTF-1016
Feature: As a tda api client, i want to get the history of requested attribute for ESV Version

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Fetch history of requested attribute for ESV Version

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def esvVersionId = karate.jsonPath(tdLines, "esv.esvVersionId")

    Given path '/api/v1/technical-definitions/expected-solution-variant-version', esvVersionId ,
    And param column = '<columnName>'
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
      | columnName |
      | quantity |
      | genericSolution|

