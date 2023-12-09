@ignore
#Tested by TDPTF-1034
Feature: As a tda api client, I want to Find the list of Technical Definitions by tdId grouped by Applied and Available

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Find the list of Technical Definitions by tdId grouped by Applied and Available

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And def tdId = response.tdId

    Given path '/api/v1/technical-definitions/', tdId ,'/project-applicabilities'
    And param code = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
