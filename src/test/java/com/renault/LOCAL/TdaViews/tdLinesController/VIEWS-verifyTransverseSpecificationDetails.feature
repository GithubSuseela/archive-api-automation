Feature: As a tda api client, I want to verify Transverse Specification details which is available for the TD line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario: [Views] Verify the Transverse Specification details

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = 2
    When method get
    Then status 200
    And match response  ==  '#present'
    * def transverseDoc = {"note": "#string", "freeDesignation": "#string"}
    * def unitCode = {"code": "#string", "nameEn": "#string", "nameFr": "#string"}
    * def transDocFirstLine = karate.jsonPath(response, "$..lines[0].transverseSpecification.transverseDocumentation")
    * def unitCodeFirstLine = karate.jsonPath(response, "$..lines[0].transverseSpecification.unit")
#    * print transDocFirstLine
#    * print unitCodeFirstLine
    And match $..lines[*].transverseSpecification.lineNumber contains "#string"
    And match $..lines[*].transverseSpecification.transverseDocumentation contains transverseDoc
    And match $..lines[*].transverseSpecification.unit contains unitCode
