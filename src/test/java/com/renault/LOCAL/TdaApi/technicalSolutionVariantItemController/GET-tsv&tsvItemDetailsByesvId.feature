@ignore
#Tested by TDPTF-1050
Feature: As a tda api client, I want to get the TSV and TSV Item details based on esvId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  GET - 200 - Fetch TSV and TSV Item details based on esvId

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
    And def esvVerId = karate.jsonPath(tdLines, "esv.esvVersionId")

    Given path '/api/v1/technical-solution-variant-items'
    And param esvVersionId = esvVerId
    When method get
    Then status 200
    And match response  ==  '#present'
