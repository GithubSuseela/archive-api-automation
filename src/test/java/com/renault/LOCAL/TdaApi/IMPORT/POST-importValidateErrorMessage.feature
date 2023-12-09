Feature: As a tda api client, validate the error message when invalid LineId and Column key is passed in the import request

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 200 - Validate the error message for invalid LineId and Column key

    # Get transversal Td code
    Given path '/api/v1/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
    And def tdCode = platform.tdCode
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
          "value": <LineId>
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
          "columnKey": <coca>,
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
    * def tdLineNotFoundResponse =
    """
    {
      "errorDescription": "TD_LINE_NOT_FOUND",
      "errors": [
        {
          "errorType": "functional",
          "errorMessage": "The specified TD Line could not be found",
          "errorCode": "TD_LINE_NOT_FOUND",
          "errorLevel": "error"
        }
      ]
    }
    """
    * def invalidColumnKeyResponse =
    """
    {
      "errorDescription": "INVALID_COLUMN_KEY",
      "errors": [
        {
          "errorType": "functional",
          "errorMessage": "The specified import column [[COCCCA]] is not valid",
          "errorCode": "INVALID_COLUMN_KEY",
          "errorLevel": "error"
        }
      ]
    }
    """
    Given path '/api/v1/technical-definitions/', 3 ,'/lines/line-import'
    And request reqData
    When method post
    Then status <status>
    And match response  ==  '#present'
    And match response == <expected>

    Examples:
      |LineId|Kind|Site|COCA|UserComment|gfeCode|gpCode|partNumber|quantity|status|expected|coca|
      | 23456|"INT_VEH" |"Test"|"GREEN"|"test comment"|"GF_11"|"R6780003-"|"284423297R"|5|400|tdLineNotFoundResponse|"COCA"|
      | #(lineId)|"INT_VEH" |"Test"|"GREEN"|"test comment"|"GF_11"|"R6780003-"|"284423297R"|5|400|invalidColumnKeyResponse|"COCCCA"|