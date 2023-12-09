Feature: As a tda client, I want to update an Technical Solution Variant Item based on tdItemId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 200 - Update Technical Solution Variant Item based on tdItemId
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
    * def esvVersionId = $.esv.esvVersionId
    * print 'ESV Version Id is: ', esvVersionId

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
#    * print response
#    * def latestUpdatedAt = $.tsvItem.updatedAt

    # Verify the Updated date of the part Number from BOMC
    Given path '/api/v1/parts/', <PartNumber>
    When method get
    Then status 200
    And match response  ==  '#present'
    * assert response.partId == <PartNumber>
#    * match response.updateDate == latestUpdatedAt

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

