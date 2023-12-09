@ignore
#Tested by TDPTF-1036
Feature: As a tda api client, I want to get the expected solution variant ids based on a technical solution variant id and a list of (optional) TD code and (optional) GFE packs

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET- 200 - Fetch the expected solution variant ids based on a tsv id and a list of (optional) TD code and (optional) GFE packs

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
    And def tsvId = karate.jsonPath(tdLines, "ts.tsv.id")

    Given path '/api/v2/technical-solution-variant/', tsvId ,'/expected-solution-variants/ids'
    When method get
    Then status 200
    And match response  ==  '#present'
