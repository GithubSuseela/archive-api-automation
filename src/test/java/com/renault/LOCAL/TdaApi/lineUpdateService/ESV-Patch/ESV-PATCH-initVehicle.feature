Feature: As a tda client, I want to update the initVehicle attribute value

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: ESV LineUpdateService - Verify the update of initVehicle attribute value
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
    * def esvId = $.esv.id
    * print 'ESV Id: ', esvId
    * def esvVersionId = $.esv.esvVersionId
    * print 'ESV Version Id: ', esvVersionId

   # Verify the update of Valid initVehicle attribute value
    * def esvReqData = {"initVehicle": "Test Init value", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"gfeCode": "GFE_11", "initVehicle": "Test Init value", "lineId": #(lineId), "esvVersionId": #(esvVersionId)}
    And print "Valid initVehicle attribute value is updated successfully"

    # Verify update of blank/null initVehicle attribute value
    * def esvReqData = {"initVehicle": "", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"initVehicle": "", "updatedByIpn": "z014082"}
    And print "Blank/Null initVehicle value is updated successfully"

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'
