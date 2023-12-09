Feature: As a tda client, I want to update the gfeCode attribute

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: ESV LineUpdateService - Verify gfeCode update
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
   # Verify the update of Valid GFE Code
    * def esvReqData = {"gfeCode": "GFE_12", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"gfeCode": "GFE_12", "lineId": #(lineId), "esvVersionId": #(esvVersionId)}
    And print "Valid GFE CODE is updated successfully"
   # Verify the update of InValid GFE Code
    * def esvReqData = {"gfeCode": "GF12", "updatedByIpn": "z014082"}
    * def errorResp =
    """
        {
      "errorDescription": "DATA_MISSING_ERROR",
      "errors": [
        {
          "errorType": "functional",
          "errorMessage": "GFE code not found",
          "errorCode": "DATA_MISSING_ERROR",
          "errorLevel": "error"
        }
      ]
    }
    """
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 400
    And match response == errorResp
    And print "Invalid GFE CODE is not updated"
    # Verify the update of GFE Code as blank/null value
    * def esvReqData = {"gfeCode": "", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"gfeCode": "", "lineId": #(lineId), "esvVersionId": #(esvVersionId)}
    And print "Blank/Null GFE CODE is updated successfully"

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'
