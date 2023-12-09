@ignore
#Tested by TDPTF-1018
Feature: As a tda api client, i want to fetch the history of applicability status

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch the history of applicability status by tdId and esvId

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
    And def tdId = tdLines.id
    And def esvLineId = karate.jsonPath(tdLines, "esv.lineId")

    Given path '/api/v1/technical-definitions', tdId ,'/lines', esvLineId ,'/history'
    When method get
    Then status 200
    And match response  ==  '#present'
