Feature: As a tda api client, i want to get the history of requested attribute

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Fetch history of requested attribute

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
#    * def vehicle = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE' && @.company=='RENAULT')]")[0]
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]
    * match platform  ==  '#present'

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    * def platformId = response.id

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    * def tdLines = karate.jsonPath(response, "$.content[?(@.assemblyPosition!='NONE')]")[0]
    And match tdLines == '#present'
    * def tdiId = tdLines.id

    Given path '/api/v1/technical-definitions/specific-data', tdiId
    And param column = '<ColumnName>'
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
    |ColumnName|
    |makeOrBuy |
    |expectedDmu|
    |forecastDiversity|