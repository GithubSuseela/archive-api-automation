Feature: As a tda client, I want to Update TD Item Status

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: PUT - 204 - Update TD Item Status

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

    #Request to create td line in platform
    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', platformTdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
#    * print response
    And match response == '#present'
    * def cocaStatus = $.tdItem.cocaStatus
    * def maturity = $.tdItem.status
    * def lineId = $.esv.lineId
    * def esvId = $.esv.id
    * def platformTdItemId = $.tdItem.id
    * def platformTdId1 = $.id
    * print 'esv id:', esvId
    * print 'platform tdItemId:', platformTdItemId
    * print 'line number:', lineId
    * print 'platform TdId:', platformTdId1

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
    Given path '/api/v1/technical-definitions/', platformTdId1, '/applicabilities'
    And request applicationFirstAppReqData
    When method post
    Then status 200
    * def vehicleFirstAppTdLineId = $.item.id
    * print 'vehicleFirstAppTdLineId:', vehicleFirstAppTdLineId

    Given path '/api/v1/technical-definitions/', platformTdId1, '/td-lines'
    And param esvIds = esvId
    When method get
    Then status 200
    * def vehicleFirstAppTdItemId = $.tdLines[0].tdItem.id
    * print 'vehicleFirstAppTdItemId:', vehicleFirstAppTdItemId

    #Request to get range lexion of master td
    Given path '/api/v1/technical-definitions/', platformTdId1, '/range-lexicon-items'
    When method get
    Then status 200
    * assert response.rangeLexiconItems.length > 0
    * def forecastDiversity = $.rangeLexiconItems[0].criteria

    #Request to update forecast diversity
    * def tdItemForecastDiversityJson =
      """
      {
          "forecastDiversity": #(forecastDiversity),
          "updatedByIpn": "karate"
       }
      """
    Given path '/api/v1/technical-definition-items/', vehicleFirstAppTdItemId, '/specific-data'
    And request tdItemForecastDiversityJson
    When method put
    Then status 204

    #Request to change td line status to RTU
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
    * print 'change status to RTU for platform td line is ok'
