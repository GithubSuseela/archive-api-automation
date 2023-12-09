Feature: As a tda client, I want to create applicability validations

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 201 - create applicability validations

#    * def randomNumber = function(max){ return Math.floor(Math.random() * max) }

    #set url to tda api
    * url tda_api_url

  # Request to create td line in platform
    * def tdCode = "3"
    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
#    * def cocaStatus = $.tdItem.cocaStatus
#    * def maturity = $.tdItem.status
    * def lineId = $.esv.lineId
    * def esvId = $.esv.id
    * def platformTdItemId = $.tdItem.id
    * print 'esv id:', esvId
    * print 'platform td item id:', platformTdItemId
    * print 'line number:', lineId
    * def esvVersionId = $.esv.esvVersionId
    * print 'ESV VersionId: ', esvVersionId
    * def maturity = 'RTU'
    * def cocaStatus = 'RED'
#    Request to enter part number, GP code and current weight
    * def updateReq =
    """
     {
        "genericPartCode": {
        "value": "R6780003-"
      },
        "knownOneDicoGenericPartCode": {
        "value": true
      },
        "partNumber": {
        "value": "751757868R"
      },
        "coleaderFlag": {
        "value": true
      },
        "knownBomLegacyFinalPartNumber": {
        "value": true
      },
        "currentWeight": {
        "value": 10
      },
        "updatedByIpn": {
        "value": 'z014082'
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = platformTdItemId
    And request updateReq
    When method patch
    Then status 200
    And match response == '#present'
    * print 'Part Number, GP Code & Current Weight attributes are updated successfully'
#    Request to change COCA status
    * def tdItemCocaStatusReqData =
      """
      {
          "cocaStatus": #(cocaStatus)
       }
      """
    Given path '/api/v1/technical-definition-items/', platformTdItemId, '/coca-status'
    And request tdItemCocaStatusReqData
    When method put
    Then status 204
    * print 'change coca to blue for platform td line is ok'

    #Request to change the Quantity attribute
    * def updateQuantityReq =
    """
    {
    "quantity": 10,
    "updatedByIpn": "z014082"
    }
    """
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request updateQuantityReq
    When method patch
    Then status 200
    And match response == '#present'
    * print 'Quantity attribute is updated successfully'

    # Request to apply FirstApp for the obeya project (Applicability Tab)
    * def firstAppReq =
    """
       {
        "lineNumber": #(lineId),
        "proposedApplication": "FIRST_APP",
        "proposedForTechnicalDefinitionCode": 32
        }
    """
    Given path '/api/v1/technical-definitions/', tdCode ,'/applications/application-proposal'
    And request firstAppReq
    When method post
    Then status 200
    And match response == '#present'
    * print 'First App applied to Obeya project is ok'

   # Request to update forecast diversity and Make or Buy (Specific data)
    * def specDataUpdateReq =
      """
      {
        "forecastDiversity": {
          "value": "BJA"
        },
        "makeOrBuy": {
          "value": "MOB"
        },
        "updatedByIpn": {
          "value": "z014082"
        }
      }
      """
    Given path '/api/v1/technical-definition-items/', platformTdItemId, '/specific-data'
    And request specDataUpdateReq
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"makeOrBuy":"MOB",  "forecastDiversity":"BJA"}
    * print 'Forecast Diversity and Make or Buy attribute values are updated successfully'
    #Request to change td line in vehicle to RTU
    * def firstAppLineToRTUReqData =
      """
      {
          "tdiStatus": #(maturity)
       }
      """
    Given path '/api/v1/technical-definition-items/', platformTdItemId, '/status'
    And request firstAppLineToRTUReqData
    When method put
    Then status 204
    * print 'Fist App Line Status changed to RTU successfully'
