@ignore
Feature: As a tda api client, i want to get esv based on td project TD id and ESV id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch esv based on td project TD id and ESV id

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id
    And def tdCode = response.projectTdCode

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def lineId = karate.jsonPath(tdLines, "esv.lineId")
    And def tdSource = tdLines.tdItem.tdSource
    And def lineId1 = tdLines.esv.lineId

    Given path '/api/v1/expected-solution-variants'
    And param sourceLineNumber = lineId1
    And param sourceTdCode = platform.code
    And param tdSource = tdSource
    When method get
    Then status 200
    And match response  ==  '#present'