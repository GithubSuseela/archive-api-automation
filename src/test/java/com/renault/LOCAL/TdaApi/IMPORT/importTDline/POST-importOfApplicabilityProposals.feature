Feature: As a tda api client, I want to import applicability for a vehicle TD

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 201 - Import single Applicability

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
#   VehicleTdCode 147 - X13C-P13C-RESENDE BRA (RE7 ENV) && ForecastDiversity (P13C....)
#   VehicleTdCode 106 - X13C-P13C-OPPAMA (RE7 ENV - Non Obeya) && ForecastDiversity (P13C....)
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
          "columnKey": "QUANTITY",
          "value": <quantity>
        },
        {
          "columnKey": "PART_NUMBER",
          "value": <partNumber>
        },
        {
          "columnKey": "GENERIC_PART_CODE",
          "value": <gpCode>
        },
        {
          "columnKey": "COCA",
          "value": <coca>
        },
      ],
      "applicationProposals": [
          {
            "proposedApplication": "YES",
            "proposedForTechnicalDefinitionCode": <vehicleTdCode>
          }
      ]
    }
    """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/line-import'
    And request reqData
    When method post
    Then status <status>
    And match response  ==  '#present'
    * print response

    Examples:
      |gfeCode|quantity|partNumber|gpCode|coca|vehicleTdCode|status|
      |"GFE_11"|"5"|"751757868R"|"R6780003-"|"GREEN"|"147"  |200   |


