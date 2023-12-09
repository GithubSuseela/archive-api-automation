Feature: As a tda client, I want to Reuse the solution of a TD line in another TD Line (by copy)

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Reuse the solution of a TD line in another TD Line (by copy)

#   POST - Create a new TD line
    * def tdCode = "<TDCode>"
    * def newLine =
    """
        {
          "gfeCode": "GFE_11",
          "tdSource": "ONE TD"
        }
        """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    * def tdItemId = $.tdItem.id
    * print 'TD Item Id:', tdItemId
    * def lineId = $.esv.lineId
    * print 'Line Id: ', lineId

    #    PATCH - update Technical Solution Variant Item for the created line
    * def reqData =
    """
     {
        "partNameEn": {
        "value": "TUBE-FUEL RETURN"
      },
        "partNameFr": {
        "value": "CANALISATION RETOUR CARBURANT"
      },
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
    * print response
 #    POST - /api/v1/technical-definitions/{tdCode}/lines/engineering-solution-reuse
    * def solutionReuseRequestData  =
    """
     {
        "lineNumber": '#(lineId)',
        "reuseSolutionOfLineNumber": "Generic Solution"
    }
    """
    Given path '/api/v1/technical-definitions/', <TDCode> ,'/lines/engineering-solution-reuse'
    And request solutionReuseRequestData
    When method post
    Then status 201
    And match response == '#present'
#    * print response

    # Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'

    Examples:
      |TDCode|PartNumber|
      |3     |'751757868R'|
#    |3     |'7703072426'|
#    |3     |'9360494949'|


