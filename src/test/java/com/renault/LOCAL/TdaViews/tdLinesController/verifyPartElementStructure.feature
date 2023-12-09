Feature: As a tda api client, I want to be able to get information regarding the part structure element node.

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: [Views] Fetch partStructureElement

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = 3
    And param requestedBy = 'z014082'
    When method get
    Then status 200
    And match response  ==  '#present'
    And def elementTypeHEAD = karate.jsonPath(response, "$.lines[?(@.transverseSpecification.partStructureElement.elementType=='HEAD')]")
    And def elementTypeComponent = karate.jsonPath(response, "$.lines[?(@.transverseSpecification.partStructureElement.elementType=='COMPONENT')]")
    And def elementTypeComposite = karate.jsonPath(response, "$.lines[?(@.transverseSpecification.partStructureElement.elementType=='COMPOSITE')]")
#    * print elementTypeHEAD
#    * print elementTypeComponent
#    * print elementTypeComposite
    And match elementTypeHEAD[*].transverseSpecification.partStructureElement contains {"elementType": "HEAD"}
    And match elementTypeComponent[*].transverseSpecification.partStructureElement contains {"elementType": "COMPONENT", "parentElement": {"lineNumber": "#string"}}
    And match elementTypeComposite[*].transverseSpecification.partStructureElement contains {"elementType": "COMPOSITE", "parentElement": {"lineNumber": "#string"}}






#    And def elementTypeComponent = karate.jsonPath(response, "$..lines[*].transverseSpecification.partStructureElement[?(@.elementType=='COMPONENT')]")
#    And def elementTypeComposite = karate.jsonPath(response, "$..lines[*].transverseSpecification.partStructureElement[?(@.elementType=='COMPOSITE')]")

#    * print elementTypeComponent
#    * print elementTypeComposite


#    * def documentFunction = {"documentCode": "#string", "nameFr": "#string", "nameEn": "#string"}
#    * def businessFunction = {"businessCode": "#string", "nameFr": "#string", "nameEn": "#string"}
##    * def transverseBusinessFunction = karate.jsonPath(response, "$..lines[0].transverseSpecification.businessFunction")
##    * def transverseDocumentFunction = karate.jsonPath(response, "$..lines[0].transverseSpecification.documentFunction")
##    * print transverseBusinessFunction
##    * print transverseDocumentFunction
#    And match $..lines[*].transverseSpecification.lineNumber contains "#string"
#    And match $..lines[*].transverseSpecification.businessFunction contains businessFunction
#    And match $..lines[*].transverseSpecification.documentFunction contains documentFunction
