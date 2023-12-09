Feature: As a tda client, I want to Create and update Part Association

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST & PUT - Create & Update Part Association
    #   POST - Create Part Association
     * def partAssociationCreation =
        """
        {
          "associatedPartId": <ALMP>,
          "associationType": "Symmetric",
          "origin": "1-TD"
        }
        """
    Given path '/api/v1/parts/', <PartNumber> ,'/part-associations'
    And request partAssociationCreation
    When method post
    Then status 201
    * print response
    And match response == 'true'

    # Verify by GET Part Associations
    Given path '/api/v1/parts/', <PartNumber> ,'/part-associations'
    When method get
    Then status 200
    And match response  ==  '#present'
    * print response
#    * assert response.partId == <PartNumber>
##    * match response.updateDate == latestUpdatedAt

    # Update Part Association (deactivate)
    * def updateRequestData =
        """
       {
          "validity": "DEACTIVATED"
        }
        """
    Given path '/api/v1/parts/', <ALMP> ,'/part-associations/', <PartNumber>
    And request updateRequestData
    When method put
    Then status 200
    * print response

    Examples:
    |PartNumber|ALMP|
    |'7703072426'|'ALMP18190R'  |
#    |'751757868R'|'ALMP13535R'  |
#    |'7703072426'|'ALMP0A003A'  |
