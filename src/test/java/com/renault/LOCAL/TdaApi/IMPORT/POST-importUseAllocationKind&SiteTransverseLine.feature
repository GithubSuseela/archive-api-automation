Feature: As a tda api client, validate the error message when I update Transversal Td Line with Use Allocation Kind and Site attributes

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 200 - Error message when use allocation Kind and Site attributes are updated for Transversal line

    # Get transversal Td code
    Given path '/api/v1/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
    And def tdCode = platform.tdCode
    * print "Td Code: ",tdCode
    # Create a Transversal td Line
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
    * def errorResponse =
    """
    {
      "errorDescription": "TD_LINE_HAS_NO_SPECIFIC_DATA",
      "errors": [
        {
          "errorType": "functional",
          "errorMessage": "The specified TD line has no specific data",
          "errorCode": "TD_LINE_HAS_NO_SPECIFIC_DATA",
          "errorLevel": "error"
        }
      ]
    }
    """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/line-import'
    And request reqData
    When method post
    Then status <status>
    And match response  ==  '#present'
    And match response == errorResponse

#   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'

    Examples:
      | Kind|Site|COCA|UserComment|gfeCode|gpCode|partNumber|quantity|status|
      | "INT_VEH" |"Test"|"GREEN"|"test comment"|"GFE_11"|"R6780003-"|"284423297R"|5|400|