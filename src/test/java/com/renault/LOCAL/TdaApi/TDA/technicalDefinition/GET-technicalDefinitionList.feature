Feature: As a tda client, I want to Get the list of technical definitions

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Get the list of technical definitions

    Given path '/api/v1/technical-definitions'
    And param familyCode = <famCode>
    And param type = <type>
    And param code = <code>
    When method GET
    Then status 200
    And match response == '#present'
#    * print response
#    And match response contains {"ubRangeTechnicalDefinitions" : '##[]'}

    Examples:
      |famCode|type|code|
      |'PFJ'|'PLATFORM'|3|
      |'XJB'|'UB_RANGE'|174|
      |'XJB'|'PWT'|231|
      |'XJB'|'PWT_FAMILY'|223|
      |''|''|null|
      |['PFJ', 'XJB', 'XJA']|''|null|
      |''|['PLATFORM', 'UB_RANGE', 'PWT'] |null|
      |''|''|[3, 174, 223, 231]|