Feature: As a tda client, I want to validate the non Obeya project workflow

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: Non-Obeya project workflow
# Create a new line
    * def tdCode = 3
    * def requestData =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def lineId = $.esv.lineId
    * print 'Line Id: ', lineId
    * def tdItemId = $.tdItem.id
    * print 'TD ItemId:', tdItemId
    * def esvId = $.esv.id
    * print 'ESV Id: ', esvId
    * def esvVersionId = $.esv.esvVersionId
    * print 'ESV VersionId: ', esvVersionId
# update the ESV data
    * def esvReqData =
    """
      {
      "gfeCode": <GFECode>,
      "quantity": <Quantity>,
      "unitCode": <utCode>,
      "updatedByIpn": "z014082",
      "shippingUnit": <ShippingUnit>
      }
    """
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
# PATCH - update the Final Part Number & GP code
    * def reqData =
    """
     {
        "partNumber": {
        "value": <PartNumber>
      },
        "genericPartCode": {
        "value": <GPCode>
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = tdItemId
    And request reqData
    When method patch
    Then status 200
    And match response == '#present'
#   Update COCA status
    * def tdItemCocaStatusReqData =
      """
      {
          "cocaStatus": <COCA>
       }
      """
    Given path '/api/v1/technical-definition-items/', tdItemId, '/coca-status'
    And request tdItemCocaStatusReqData
    When method put
    Then status 204
    * print 'change coca to GREEN for platform td line is ok'
    # Request to apply FirstApp for the obeya project (Applicability Tab)
        # VehicleTdCode 147 - X13C-P13C-RESENDE BRA (RE7 ENV) && ForecastDiversity (P13C....)
        # VehicleTdCode 106 - X13C-P13C-OPPAMA (RE7 ENV - Non Obeya) && ForecastDiversity (P13C....)
        # VehicleTdCode 184 - X1310-SUV-BURSA TUR (TES ENV) && ForecastDiversity (VT13....)
        # VehicleTdCode 40 - XJA-BJA_PH2-BURSA (QUA ENV) && ForecastDiversity (BJA)
    * def firstAppReq =
    """
       {
        "lineNumber": #(lineId),
        "proposedApplication": "FIRST_APP",
        "proposedForTechnicalDefinitionCode": 40
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
        }
      }
      """
    Given path '/api/v1/technical-definition-items/', tdItemId, '/specific-data'
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
          "tdiStatus": <TdiStatus>
       }
      """
    Given path '/api/v1/technical-definition-items/', tdItemId, '/status'
    And request firstAppLineToRTUReqData
    When method put
    Then status 204
    * print 'Fist App Line Status changed to RTU successfully'

    Examples:
      |GFECode|Quantity|ShippingUnit|utCode|PartNumber|COCA|GPCode|TdiStatus|
      |"GFE_11" |1       |"ORDER_LEVEL"|"SV"   |'751757868R'|'GREEN'|'R6780003-'|'RTU'|