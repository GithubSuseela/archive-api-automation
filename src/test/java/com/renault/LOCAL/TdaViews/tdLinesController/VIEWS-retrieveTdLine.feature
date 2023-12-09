Feature: As a tda api client, I want to the retrieve the right TDline when in the search criteria (lineNumber) is specified

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario: [Views] Retrieve a LineNumber

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = 2
    When method get
    Then status 200
    And match response  ==  '#present'
    And def firstLine = karate.jsonPath(response, "$..lines[0]")
#    * print firstLine
    * def LineId = firstLine[0].identity.lineNumber
    * print 'Line Number:', LineId
    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param lineNumber = LineId
    And param technicalDefinitionCode = 2
    When method get
    Then status 200
    And match response  ==  '#present'
    And match $..lines[0].identity contains {"lineNumber": "#string", "technicalDefinitionCode": 2}

