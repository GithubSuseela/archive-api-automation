
Feature: As a tda api client, I want to Create a new line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: Create a new line and verify the default values

#   POST - Create a new TD line
    * def tdCode = "3"
    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    * def expectedTdItemValues =
    """
     {
      "companyMembership": "RENAULT",
      "tdSource": "ONE TD",
      "cocaStatus": "GREY",
      "status": "DRAFT",
      "forecastDiversityValidity": false
      }
     """
    And def expectedEsvValues =
    """
    {
        "genericSolution": {
        "knownOneDicoGenericPartCode": false,
        "solutionNumber": '#string'
        },
      "freeDesignation": "",
      "lineId": '#string',
      "id": '#uuid',
      "esvVersionId": '#uuid',
      "gfeCode": "GFE_11",
      "scopePart": "PF"
    }
    """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
#    * print response
    And def tdItemId = $.tdItem.id
    * print 'TD ItemId:', tdItemId
    And match $.tdItem contains expectedTdItemValues
    And match response contains {"assemblyPosition": "NONE"}
    And match $.esv contains expectedEsvValues
    And match response contains {"version": "0.0"}
    And match $.ts.tsvItem contains {"coleaderFlag": false}
    And match $.ts.tsvItem.coleaderFlag != null

# Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'
