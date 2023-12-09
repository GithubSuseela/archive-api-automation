Feature: As a tda client, I want to specify the details of a part modification

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 200 - Specify the details of a part modification

#   POST - Create a new TD line
    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
#    * def esvId = $.esv.id
#    * print 'ESV Id: ', esvId
    * def tdItemId = $.tdItem.id
    * print 'TD ItemId:', tdItemId
    * def lineId = $.esv.lineId
    * print 'Line Id: ', lineId
#   PATCH - Update part id
    * def reqData =
    """
     {
        "partNumber": {
        "value": <PartNumber>
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = tdItemId
    And request reqData
    When method patch
    Then status 200
    And match response == '#present'
#    * print response
# update DUS (designUpdateSheetNumber) and LUP (issueNumber) numbers of the part id
    * def reqData =
    """
    {
      "designUpdateSheetNumber": <dus>,
      "issueNumber": <lup>,
      "lineNumber": '#(lineId)'
    }
    """

    * def resp =
    """
    {
      "partModification": {
        "designUpdateSheetNumber": <dus>,
        "issueNumber": <lup>
      },
      "partSolutionEdited": {
        "inLineNumber": '#(lineId)',
        "partId": '#string'
      }
    }
    """

    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/part-modification'
    And request reqData
    When method post
    Then status <status>
    And match response == '#present'
    And match response == <expected>

#   Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'

    Examples:
      |tdCode|PartNumber|dus|lup|status|expected|
      |3     |'215035507R'|'Test Dus'|'Test Lup'|200|resp   |
