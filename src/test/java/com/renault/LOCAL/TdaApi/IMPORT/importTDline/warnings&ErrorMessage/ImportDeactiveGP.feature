Feature: As a tda api client, I want to update the ESV data through import for an existing TD line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 201 - Import valid ESV data for a new line

    # Get Platform code
    Given path '/api/v1/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
    And def tdCode = platform.tdCode
    * print "Td Code: ",tdCode
#    * print platform

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
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/line-import'
    And request reqData
    When method post
    Then status <Status>
    And match response  ==  '#present'
    * print response
#    * def expectedResponse =
#    """
#     {
#        "gfeCode": "GFE_11",
#        "functionCode": "F15266---",
#        "nissanFunctionCode": "G27071---",
#        "initVehicle": "Test Init",
#        "initPart": "7703042086",
#        "unitCode": "SV",
#        "quantity": 2,
#        "departmentCode": "2C1"
#      }
#    """
##    Verify the imported data in the td line
#    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
#    And param esvLineIds = lineNumber
#    When method get
#    Then status 200
#    And match response  ==  '#present'
##    And match $.tdLines[0].esv contains <expected>

    Examples:
      |gfeCode|rFuncCode|nFuncCode|initVehicle|motherPart|sourceId|unitCode|quantity|gpCode|deptCode|Status|expected|
      |"GFE_63"|"F15266---"|"G27071---"|"Test Init"|"7703042086"|"23544"|"SV"|2|"F10728/AM"|"2C1"|200|expectedResponse|





