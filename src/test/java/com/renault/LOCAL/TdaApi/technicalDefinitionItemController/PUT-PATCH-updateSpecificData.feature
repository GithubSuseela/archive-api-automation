Feature: As a tda client, I want to update Specific Data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: PATCH & PUT methods - Update Specific Data

    * def randomNumber = function(max){ return Math.floor(Math.random() * max) }
    #Request to get first PLATFORM and all VEHICLES' code
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM'&&@.site=='ALL')]")[0]
    * def platformCompany = platform.company
    * print platform.company
    * def vehicleTdCodes = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE' && @.company=='" + platformCompany + "' && !(@.name =~ /.*TEST.*/i) && !(@.comment =~ /.*TEST.*/i))].code")
    * match platform == '#notnull'
    * def vehicleIdx = randomNumber(vehicleTdCodes.length - 1)
    * def vehicleFirstAppIdx = vehicleIdx + 1
    * def vehicleTdCode = vehicleTdCodes[vehicleIdx]
    * def vehicleFirstAppTdCode = vehicleTdCodes[vehicleFirstAppIdx]
    * def platformTdCode = platform.code
    * print 'platform td code:', platformTdCode
    * print 'vehicle td code:', vehicleTdCode

	#Request to get platform id
    Given path '/api/v1/technical-definitions/code', platformTdCode
    When method get
    Then status 200
    * def platformTdId = $.id
    * print 'platform td id:', platformTdId

    #Request to get vehicle id (first app)
    Given path '/api/v1/technical-definitions/code', vehicleFirstAppTdCode
    When method get
    Then status 200
    * def vehicleFirstAppTdId = $.id
    * print 'vehicle first app td id:', vehicleFirstAppTdId

    #Request to get vehicle id (obeya)
    Given path '/api/v1/technical-definitions/code', vehicleTdCode
    When method get
    Then status 200
    * def vehicleTdId = $.id
    * print 'vehicle td id:', vehicleTdId

    #Request to create td line in platform
    Given path '/api/v1/technical-definitions/', platformTdId, '/td-lines'
    And request {}
    When method post
    Then status 201
    * def cocaStatus = $.tdItem.cocaStatus
    * def maturity = $.tdItem.status
    * def lineId = $.esv.lineId
    * def esvId = $.esv.id
    * def platformTdItemId = $.tdItem.id
    * print 'esv id:', esvId
    * print 'platform td item id:', platformTdItemId
    * print 'line number:', lineId

    * def maturity = 'RTU'
    * def cocaStatus = 'BLUE'
    #Request to change td line in vehicle to RTU
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

    #Request to FIRST APP
    * def applicationFirstAppReqData =
      """
      {
          "applicability": "FIRST_APP",
          "esvVersionId": #(esvId),
          "userIpn": "karate"
       }
      """
    Given path '/api/v1/technical-definitions/', vehicleFirstAppTdId, '/applicabilities'
    And request applicationFirstAppReqData
    When method post
    Then status 200
    * def vehicleFirstAppTdLineId = $.item.id
    * print 'vehicleFirstAppTdLineId:', vehicleFirstAppTdLineId

    Given path '/api/v1/technical-definitions/', vehicleFirstAppTdId, '/td-lines'
    And param esvIds = esvId
    When method get
    Then status 200
    * def vehicleFirstAppTdItemId = $.tdLines[0].tdItem.id
    * print 'vehicleFirstAppTdItemId:', vehicleFirstAppTdItemId

        #Request to get range lexion of master td
    Given path '/api/v1/technical-definitions/', platformTdId, '/range-lexicon-items'
    When method get
    Then status 200
    * assert response.rangeLexiconItems.length > 0
    * def forecastDiversity = $.rangeLexiconItems[0].criteria

    #Request to updpate forcast diversity
    * def tdItemForcastDiversityJson =
      """
      {
          "forecastDiversity": #(forecastDiversity),
          "updatedByIpn": "karate"
       }
      """
    Given path '/api/v1/technical-definition-items/', vehicleFirstAppTdItemId, '/specific-data'
    And request tdItemForcastDiversityJson
    When method put
    Then status 204

    #Request to change td line in vehicle to RTU
    * def firstAppLineToRTUReqData =
      """
      {
          "tdiStatus": #(maturity)
       }
      """
    Given path '/api/v1/technical-definition-items/', vehicleFirstAppTdItemId, '/status'
    And request firstAppLineToRTUReqData
    When method put
    Then status 204

    #Request to patch final part number, gp code
    * def patchPlatformTdLineReqData =
      """
      {
        "genericPartCode": {
           "value": "F10001/AC"
         },
         "knownOneDicoGenericPartCode": {
          "value": true
        },
        "partNumber": {
           "value": "21430AX30A"
        },
        "coleaderFlag": {
           "value": true
        },
        "knownBomLegacyFinalPartNumber": {
          "value": true
        }
       }
      """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = platformTdItemId
    And request patchPlatformTdLineReqData
    When method patch
    Then status 200

    * def esvReqData =
    """
      {
      "quantity": 1
      }
    """
    Given path '/api/v1/expected-solution-variants/', esvId
    And request esvReqData
    When method patch
    Then status 200

    #Request to change td line in vehicle to RTU
    * def platformTdItemStatusJson =
      """
      {
          "tdiStatus": #(maturity)
       }
      """
    Given path '/api/v1/technical-definition-items/', platformTdItemId, '/status'
    And request platformTdItemStatusJson
    When method put
    Then status 204

    #Request to apply to vehicle
    * def applicationJson =
      """
      {
          "applicability": "TO_VALIDATE_YES",
          "esvVersionId": #(esvId),
          "userIpn": "karate"
       }
      """
    Given path '/api/v1/technical-definitions/', vehicleTdId, '/applicabilities'
    And request applicationJson
    When method post
    Then status 200
    * def vehicleTdLineId = $.item.id
    * print 'vehicleTdLineId:', vehicleTdLineId

    * def sleep =
  """
  function(seconds){
    for(i = 0; i <= seconds; i++)
    {
      java.lang.Thread.sleep(1*1000);
      karate.log(i);
    }
  }
  """

    #Request to get vehicle td item id
    Given path '/api/v1/technical-definitions/', platformTdId, '/applied-on/', vehicleTdId, '/specific-data'
    And params {page: 0, size: 50000}
    When method get
    And call sleep 5
    Then status 200
    * def vehicleTdItemId = karate.jsonPath(response, "$.content[?(@.projectSpecificData.platformTdItemId=='" + platformTdItemId + "')].projectSpecificData.projectTdItemId")[0]
    * print 'vehicle td item id:', vehicleTdItemId
    * print vehicleTdItemId

    #Request to get range lexion of master td
    Given path '/api/v1/technical-definitions/', platformTdId, '/range-lexicon-items'
    When method get
    Then status 200
    * assert response.rangeLexiconItems.length > 0
    * def forecastDiversity = $.rangeLexiconItems[0].criteria

    #Request to update (PUT) specific data
    * def specificDataJson =
      """
      {
        "smaId": "B",
        "sourcingBatch": "RFQ",
        "sourcingCompetition": "LOT9",
        "forecastDiversity": #(forecastDiversity),
        "updatedByIpn": "Z014082"
      }
      """

    Given path '/api/v1/technical-definition-items/', vehicleTdItemId, '/specific-data'
    And request specificDataJson
    When method put
    Then status 204
    * print 'Specific data update is ok'

     #Request to update (PATCH) specific data
    * def specificDataJson =
      """
      {
          "riskOpportunity": {
            "value": "RISK"
          },
          "smaId": {
            "value": "B"
          },
          "sourcingBatch": {
            "value": "RFQ"
          },
          "sourcingCompetition": {
            "value": "LOT8"
          }
       }
      """
    Given path '/api/v1/technical-definition-items/', vehicleTdItemId, '/specific-data'
    And request specificDataJson
    When method PATCH
    Then status 200
    And match response == '#present'
    And match response contains {"smaId" : 'B', "sourcingBatch" : 'RFQ', "sourcingCompetition" : 'LOT8'}


