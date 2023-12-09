Feature: As a tda client, I want to Search TD Lines

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Search TD Lines

    Given path '/api/v1/query/technical-definition-lines'
    And param expected-solution-variants = '093fc73f-aa13-4615-be04-2e9a3d79de17'
    And param gfe-packs = 'GFE_11'
    And param technical-definitions = 161
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response
    And match response[*].tsvi contains {"finalPartNumber":"#string","partEep":"#boolean","legacyWeight":"#number","currentWeight":"#number","finalPartKind":"#string","material":"#string","partNote":"#string","finalPartDesignationFr":"#string","knownBomLegacyFinalPartNumber":"#boolean","commonalityType":"#string","id":"#string","finalPartDesignationEn":"#string","unitOfUse":"#string"}