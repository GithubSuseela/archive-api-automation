Feature: As a tda api client, I want to create or update Td Line with Use Allocation Kind and Site attributes

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 200 - Import use allocation Kind and Site attributes

    # Create a vehicle td Line
    * def requestData = {"gfeCode": "GFE_11", "tdSource": "ONE TD"}
    Given path '/api/v1/technical-definitions/', <vehicleTdCode> ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def lineId = $.esv.lineId
    * print "Line Number: ",lineId
    * def esvId = $.esv.id
    * print 'ESV Id: ', esvId

    # Import TD item data for created (existing) line
    * def reqData =
    """
    {
      "requestedBy": "z014082",
      "lineData": [
        {
          "columnKey": "LINE_ID",
          "value": #(lineId)
        },
        {
          "columnKey": "GFE_CODE",
          "value": <gfeCode>
        },
        {
          "columnKey": "GENERIC_PART_CODE",
          "value": <gpCode>
        },
        {
          "columnKey": "PART_NUMBER",
          "value": <partNumber>
        },
        {
          "columnKey": "KIND",
          "value": <Kind>
        },
        {
          "columnKey": "SITE",
          "value": <Site>
        },
        {
          "columnKey": "USER_COMMENT",
          "value": <UserComment>
        },
        {
          "columnKey": "COCA",
          "value": <COCA>
        },
        {
          "columnKey": "QUANTITY",
          "value": <quantity>
        }
      ]
    }
    """
    * def resp1 = {"lineUpdated": {"lineNumber": "#string", "technicalDefinitionCode": "#number"}}
    Given path '/api/v1/technical-definitions/', <vehicleTdCode> ,'/lines/line-import'
    And request reqData
    When method post
    Then status <status>
    And match response  ==  '#present'
    And match response contains <expected>

    #    Verify the imported data in the td line
    * def resp2 = {"useAllocation": {"site": <Site>, "kind": <Kind>}}
    Given path '/api/v1/technical-definitions/', <vehicleTdCode> ,'/lines'
    And param esvLineIds = lineId
    When method get
    Then status 200
    And match response  ==  '#present'
    And match $.tdLines[0].tdItem contains resp2

#   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [<vehicleTdCode>]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'

    Examples:
      | Kind|Site|COCA|UserComment|gfeCode|gpCode|partNumber|quantity|vehicleTdCode|status|expected|
      | "INT_VEH" |"Test"|"GREEN"|"test comment"|"GFE_11"|"R6780003-"|"284423297R"|2|106|200|resp1|




