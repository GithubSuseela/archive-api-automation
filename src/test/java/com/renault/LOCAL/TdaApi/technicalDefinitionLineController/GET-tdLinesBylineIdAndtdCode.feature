@ignore
#Tested by TDPTF-1041
Feature: As a tda api client, I want to get the Td Lines by lineId and tdCode

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch Td Lines by lineId and tdCode

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And def tdCode = response.projectCode
    And def tdId = response.tdId

    Given path '/api/v1.1/technical-definitions/', tdId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def LineId = karate.jsonPath(tdLines, "esv.lineId")

    Given path '/api/v1/technical-definitions/td-line/findByLineIdAndTdCode'
    And param lineId = LineId
    And param tdCode = tdCode
    When method get
    Then status 200
    And match response  ==  '#present'
