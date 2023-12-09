Feature: As a tda client, I want to update the Unit Code attribute value

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: ESV LineUpdateService - Verify Unit Code attribute value update
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

   # Verify the update of Valid Unit Code value
    * def esvReqData = {"unitCode": "SV", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"gfeCode": "GFE_11", "unitCode": "SV", "lineId": #(lineId), "esvVersionId": #(esvVersionId)}
    And print "Valid Unit Code value is updated successfully"

   # Verify update of InValid Unit Code attribute value
    * def esvReqData = {"unitCode": "test", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 400
    And print "Invalid Unit Code value is not updated"

    # Verify update of blank/null Unit Code attribute value
    * def esvReqData = {"unitCode": "", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response !contains {"unitCode": "SV"}
    And print "Blank/Null Unit Code value is updated successfully"

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'
