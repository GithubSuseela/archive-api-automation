Feature: As a tda client, I want to update the quantity attribute

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: ESV LineUpdateService - Verify quantity value update
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
   # Verify update of Valid quantity value
    * def esvReqData = {"quantity": 2, "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
#    * print response
    And match response contains {"gfeCode": "GFE_11", "quantity": 2, "lineId": #(lineId), "esvVersionId": #(esvVersionId)}
    And print "Valid Quantity value is updated successfully"
   # Verify update of InValid quantity value
    * def esvReqData = {"quantity": "Two", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 400
    And print "Invalid Quantity value is not updated"
    # Verify update of blank/null quantity attribute
    * def esvReqData = {"quantity": "", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response !contains {"quantity": 2}
    And print "Blank/Null QUANTITY value is updated successfully"

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'
