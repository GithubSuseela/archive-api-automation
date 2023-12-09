@ignore
#Tested by TDPTF-1166
Feature: As a tda client, I want to Export td lines (Platform) into csv format

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 200 - Export td lines (Platform) into csv format

#   Retrieve the tdId
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]
    And match platform == '#present'

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    * def tdId = response.id
    And match tdId == '#present'

#   POST - Export Platform TD lines
    * def globalHeaders = call read('classpath:headers.js')
    * set globalHeaders['Accept'] = 'application/octet-stream;charset=ISO-8859-1'
    * configure headers = globalHeaders
    Given path '/api/v1/technical-definitions/', tdId, '/platform-lines/export'
    And param langCode = 1
    And request {}
    And configure readTimeout = 150000
    When method post
    Then status 200
    And match response == '#present'
