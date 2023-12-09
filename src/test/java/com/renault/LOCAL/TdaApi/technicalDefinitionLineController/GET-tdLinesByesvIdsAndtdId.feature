#@ignore
#Tested by TDPTF-1040
Feature: As a tda api client, I want to get the Td Lines by esvIds and tdId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch Td Lines by esvIds and tdId

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And def tdId = response.tdId

    Given path '/api/v1/technical-definitions/' , tdId ,'/technical-definition-lines'
    When method get
    Then status 200
    And match response == '#present'

