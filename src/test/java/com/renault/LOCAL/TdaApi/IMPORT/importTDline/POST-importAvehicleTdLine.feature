Feature: As a tda api client, I want to create or update a vehicle Td Line with provided line data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 201 - create a vehicle Td Line and update the provided line data

    # Create a new Line
    * def requestData = {"gfeCode": "GFE_11", "tdSource": "ONE TD"}
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def lineNumber = $.esv.lineId
    * print "Line Number: ",lineNumber
    * def esvId = $.esv.id
    * print 'ESV Id: ', esvId

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
        { "columnKey": "SOURCE_ID",
          "value": "403"
         },
         { "columnKey": "TD_SOURCE",
           "value": "IMPTEST"
          }
         ]
        }
    """
    * def resp1 = {"lineUpdated": {"lineNumber": "#string", "technicalDefinitionCode": "#number"}}
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/line-import'
    And request reqData
    When method post
    Then status <status>
    And match response  ==  '#present'
#    * print response
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
      | tdCode |gfeCode|status|expected|
      | 106 |"GFE_11"|200        |resp1   |


