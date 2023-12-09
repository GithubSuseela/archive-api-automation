Feature: As a tda api client, I want to verify the Transverse Specification (documentFunction and businessFunction) details which is available for the TD line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: [Views] Verify the Transverse Specification details (documentFunction and businessFunction)

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = 2
    And param limit = 100
    And param requestedBy = 'z014082'
    When method get
    Then status 200
    And match response  ==  '#present'
    * def documentFunction = {"documentCode": "#string", "nameFr": "#string", "nameEn": "#string"}
    * def businessFunction = {"businessCode": "#string", "nameFr": "#string", "nameEn": "#string"}
#    * def transverseBusinessFunction = karate.jsonPath(response, "$..lines[0].transverseSpecification.businessFunction")
#    * def transverseDocumentFunction = karate.jsonPath(response, "$..lines[0].transverseSpecification.documentFunction")
#    * print transverseBusinessFunction
#    * print transverseDocumentFunction
    And match $..lines[*].transverseSpecification.lineNumber contains "#string"
    And match $..lines[*].transverseSpecification.businessFunction contains businessFunction
    And match $..lines[*].transverseSpecification.documentFunction contains documentFunction
