Feature: As a tda api client, I want to get the genericPartValidity in the response when a component or composed part in an assembly has a Generic part code

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET the genericPartValidity in the response when a component or composed part in an assembly has a Generic part code

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id
#    And match platformId == '#present'

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And match response == '#present'
#    "partKind": "ASSEMBLY" ,"partKind": "PARTIAL_ASSEMBLY", "partKind": "SINGLE_PART" , "partKind": "ALLIANCE_MASTER_PART",
#    "partKind": "PART_FROM_MATERIAL_OR_ROUGH", "partKind": "COLLECTION", "partKind": "STANDARD_PART_REPETITIVE_AND_MULTI_USE",
#    And def tdLines = karate.jsonPath(response, "$.content[?(@.assemblyPosition=='PART_OF' && @.ts.tsvItem.partKind=='ASSEMBLY')]")[0]
    And def tdLines = karate.jsonPath(response, "$.content[?(@.ts.tsvItem.partKind=='ASSEMBLY')]")[0]
    And match tdLines == '#present'
#    * print tdLines
    And def esvId = karate.jsonPath(tdLines, "esv.id")
    And match esvId == '#present'
    And def partNo = karate.jsonPath(tdLines, "ts.tsvItem.partNumber")
    And match partNo == '#present'

    Given path '/api/v1/assemblies', esvId ,'/bom-part-structures'
    And param partNumber = partNo
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response