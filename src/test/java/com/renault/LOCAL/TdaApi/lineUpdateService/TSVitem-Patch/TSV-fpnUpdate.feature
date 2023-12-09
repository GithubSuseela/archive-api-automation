Feature: As a tda client, I want to update the Final part number

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: TSV LineUpdateService - Verify the update of Final Part Number
   # Create a new line
    * def tdCode = 3
    * def requestData = {"gfeCode": "GFE_11", "tdSource": "ONE TD"}
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def lineId = $.esv.lineId
    * print "Line Number: ",lineId
    * def tdItemId = $.tdItem.id
    * print 'TD ItemId:', tdItemId

   # Verify update of Valid Final Part Number attribute value
    * def tsvItemRequestData =
    """
     {
        "partNumber": {
        "value": "751757868R"
      },
        "updatedByIpn": {
        "value": "z014082"
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = tdItemId
    And request tsvItemRequestData
    When method patch
    Then status 200
    And match response == '#present'
    And match $.tsvItem contains {"partNumber": "751757868R"}

   # Verify update of Final Part Number attribute value as null/blank
    * def tsvItemRequestData =
    """
     {
        "partNumber": {
        "value": ""
      },
        "updatedByIpn": {
        "value": "z014082"
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = tdItemId
    And request tsvItemRequestData
    When method patch
    Then status 200
    And match response == '#present'
    And match $.tsvItem !contains {"partNumber": "751757868R"}

    #    Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'
