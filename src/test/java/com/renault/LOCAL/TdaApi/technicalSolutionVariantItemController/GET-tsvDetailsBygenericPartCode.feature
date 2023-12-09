@ignore
#Tested by TDPTF-1051
Feature: As a tda api client, I want to get the TSV details based on generic part code

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  GET - 200 - Fetch TSV details based on generic part code

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
    And def tsvItemId = karate.jsonPath(tdLines, "ts.tsvItem.id")

    Given path 'api/v1/technical-solution-variant-items', tsvItemId
    When method get
    Then status 200
    * print response
    And def GPCode = response.genericPartCode
    * print GPCode

    Given path '/api/v1/technical-solution-variant-items/generic-part-code'
    And param genericPartCode = GPCode
    When method get
    Then status 200
    And match response  ==  '#present'

