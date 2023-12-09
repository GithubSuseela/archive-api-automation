Feature: As a tda client, I want to update the Renault and Nissan functionCode attribute values

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: ESV LineUpdateService - Verify the update of Renault and Nissan functionCode attribute values
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
   # Verify update of Valid functionCode attribute value
    * def esvReqData = {"functionCode": "F99999---", "nissanFunctionCode": "G680D0---", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"functionCode": "F99999---", "nissanFunctionCode": "G680D0---", "lineId": #(lineId), "esvVersionId": #(esvVersionId)}
    And print "Valid functionCode value is updated successfully"

    # Verify update of blank/null functionCode attribute values
    * def esvReqData = {"functionCode": "", "nissanFunctionCode": "", "updatedByIpn": "z014082"}
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'
    And match response contains {"functionCode": "", "nissanFunctionCode": ""}
    And print "Blank/Null functionCode value is updated successfully"

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'
