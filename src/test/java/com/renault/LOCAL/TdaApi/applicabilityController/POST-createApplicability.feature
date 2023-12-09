Feature: As a tda user, I want to create or update the applicability for a project

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario: POST & PUT - 200 - creates/updates the applicability for a project

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

        # Create project applicability
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
    And match response  ==  '#present'
    #Update project applicability
    * def updateReqData =
      """
          {
              "applicability": "TO_VALIDATE_FIRST_APP",
              "esvVersionId": #(esvId),
              "userIpn": "karate"
           }
       """
    Given path '/api/v1/technical-definitions/', vehicleFirstAppTdId, '/applicabilities'
    And request updateReqData
    When method PUT
    Then status 200
    And match response  ==  '#present'