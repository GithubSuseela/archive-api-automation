Feature: As a tda client, I want to update the generic part information (bpCode,bpName, bpAddInfo)

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: ESV LineUpdateService - Verify the update of (bpCode,bpName, bpAddInfo)
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

   # Verify the update of Valid (bpCode,bpName, bpAddInfo) attribute values
    * def esvReqData = {"addBpName": "24000", "bpName": "WIRING DIAG", "bpAddInfo": "TestUpdate", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"addBpName": "24000", "bpName": "WIRING DIAG", "bpAddInfo": "TestUpdate", "lineId": #(lineId), "esvVersionId": #(esvVersionId)}
    And print "Valid (bpCode,bpName, bpAddInfo) attribute values are updated successfully"

    # Verify update of blank/null (bpCode,bpName, bpAddInfo) attribute values
    * def esvReqData = {"addBpName": "", "bpName": "", "bpAddInfo": "", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"addBpName": "", "bpName": "", "bpAddInfo": ""}
    And print "Blank/Null (bpCode,bpName, bpAddInfo) values are updated successfully"

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'
