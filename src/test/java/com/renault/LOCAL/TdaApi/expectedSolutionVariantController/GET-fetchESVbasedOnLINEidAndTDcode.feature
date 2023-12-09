Feature: As a tda api client, i want to get esv based on  LineId and TdCode

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch esv based on  LineId and TdCode

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def lineId1 = karate.jsonPath(tdLines, "esv.lineId")

    Given path '/api/v1/expected-solution-variants/findByLineIdAndTdCode'
    And param lineId = lineId1
    And param tdCode = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'

