@ignore
#Tested by TDPTF-1039
Feature: As a tda api client, I want to get the TD Item based on td project TD id and ESV id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch TD Item based on td project TD id and ESV id

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id
    And def prjTdCode = response.projectTdCode

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def esvVerId = karate.jsonPath(tdLines, "esv.esvVersionId")

    Given path '/api/v1/technical-definition-lines'
    And param esvVersionId = esvVerId
    And param projectTdCode = prjTdCode
    When method get
    Then status 200
    And match response  ==  '#present'
