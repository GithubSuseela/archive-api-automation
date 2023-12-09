Feature: As a tda api client, I want to validate the ESV data import error responses for an existing TD line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 400 - Validate the ESV data import error responses

    # Get Platform code
    Given path '/api/v1/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
    And def tdCode = platform.tdCode
    * print "Td Code: ",tdCode

    # Create a new Line
    * def requestData = {"gfeCode": "GFE_11", "tdSource": "ONE TD"}
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def lineNumber = $.esv.lineId
    * print "Line Number: ",lineNumber
    * def esvId = $.esv.id
    * print 'ESV Id: ', esvId

    # Import ESV data for created (existing) line
    * def reqData =
    """
    {
      "requestedBy": "z014082",
      "lineData": [
        {
          "columnKey": "LINE_ID",
          "value": #(lineNumber)
        },
        {
          "columnKey": "GFE_CODE",
          "value": <gfeCode>
        },
        {
          "columnKey": "FUNCTION_CODE",
          "value": <rFuncCode>
        },
        {
          "columnKey": "NISSAN_FUNCTION_CODE",
          "value": <nFuncCode>
        },
        {
          "columnKey": "INIT_VEHICLE",
          "value": <initVehicle>
        },
        {
          "columnKey": "MOTHER_PART",
          "value": <motherPart>
        },
        {
          "columnKey": "SCOPE_PART",
          "value": "PF"
        },
        {
          "columnKey": "SOURCE_ID",
          "value": <sourceId>
        },
        {
          "columnKey": "UNIT_CODE",
          "value": <unitCode>
        },
        {
          "columnKey": "QUANTITY",
          "value": <quantity>
        },
        {
          "columnKey": "GENERIC_PART_CODE",
          "value": <gpCode>
        },
        {
          "columnKey": "DEPARTMENT_CODE",
          "value": <deptCode>
        }
      ]
    }
    """
    * def gfeError = {"errorDescription":"DATA_MISSING_ERROR","errors":[{"errorType":"functional","errorMessage":"GFE code not found","errorCode":"DATA_MISSING_ERROR","errorLevel":"error"}]}
    * def unitCodeError = {"errorDescription":"INVALID_DATA_FOR_IMPORT"}
    * def gpCodeError = {"errorDescription":"DATA_MISSING_ERROR","errors":[{"errorType":"functional","errorMessage":"The Selected Generic Part Code doesn't exist in the Dictionary.","errorCode":"DATA_MISSING_ERROR","errorLevel":"error"}]}
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/line-import'
    And request reqData
    When method post
    Then status <Status>
    And match response contains <expected>

#   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'

    Examples:
      |gfeCode|rFuncCode|nFuncCode|initVehicle|motherPart|sourceId|unitCode|quantity|gpCode|deptCode|Status|expected|
      |"GFE11"|"F15266---"|"G27071---"|"Test Init"|"7703042086"|"23544"|"SV"|2|"R6780003-"|"2C1"|400|gfeError|
      |"GFE_11"|"F15266---"|"G27071---"|"Test Init"|"7703042086"|"23544"|"Test"|2|"R6780003-"|"2C1"|400 |unitCodeError|
      |"GFE_11"|"F15266---"|"G27071---"|"Test Init"|"7703042086"|"23544"|"SV"|2|"R6ST0003-"|"2C1"|400|gpCodeError|