@ignore
#Tested by TDPTF-1015
Feature: As a tda api client, I want to get the history of requested attribute for ESV

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Fetch history of requested attribute for ESV by esvId

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * print response
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And match tdLines == '#present'
    And def esvId = karate.jsonPath(tdLines, "esv.id")
    * print response

    Given path '/api/v1/technical-definitions/expected-solution-variants' , esvId ,
    And param column = '<columnName>'
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
    | columnName |
    | functionCode |
    | gfeCode |

