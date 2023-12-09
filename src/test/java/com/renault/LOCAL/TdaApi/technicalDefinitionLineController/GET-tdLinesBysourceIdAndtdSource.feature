#@ignore
##Tested by TDPTF-1156
Feature: As a tda api client, I want to get the Td Lines by sourceId and tdSource

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch Td Lines by sourceId and tdSource

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id
    And def prjTdCode = response.projectTdCode

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def srcId = karate.jsonPath(tdLines, "esv.sourceId")
    And def tdSrc = karate.jsonPath(tdLines, "tdItem.tdSource")

    Given path '/api/v1/technical-definitions/', prjTdCode, '/lines'
    And param sourceId = srcId
    And param tdSource = tdSrc
    When method get
    Then status 200
    And match response  ==  '#present'
