Feature: As a tda api client, I want to Find latest versions of Technical Definition Lines matching specified search criteria

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario Outline: GET - 200 - Find latest versions of Technical Definition Lines matching specified search criteria

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = <tdCode>
    And param applicationPolicy = <AppPolicy>
    And param specificDataPolicy = <SpecificDataPolicy>
    And param limit = <paginationLimit>
    When method get
    Then status 200
    And match response  ==  '#present'
    And match $..lines[*].lifecycle contains {"milestoneCode": "#string", "maturityLevel": "#string", "version": "#string"}

    Examples:
    |tdCode|AppPolicy|SpecificDataPolicy|paginationLimit|
    |2     |'ACTIVE_APPLICATIONS'|'NEVER'|10|
    |2     |'ACTIVE_APPLICATIONS'|'NEVER'|100|
    |3     |'ACTIVE_APPLICATIONS'|'NEVER'|1000|
