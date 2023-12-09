@ignore
#Tested by TDPTF-104é
Feature: As a tda api client, I want to get the Td Lines by tdCode and esvLineIds

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch Td Lines by tdCode and esvLineIds

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def esvLineId = karate.jsonPath(tdLines, "esv.lineId")

    Given path '/api/v1/technical-definitions/' , platform.code ,'/lines'
    And param esvLineIds = esvLineId
    When method get
    Then status 200
    And match response  ==  '#present'