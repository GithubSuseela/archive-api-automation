Feature: As a tda client, I want to Create a TD Line by tdCode

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 201 - Create a TD Line by TD code

    # Create a new line (Parent)
    * def tdCode = 3
    * def requestData =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
#    * def tdItemId = $.tdItem.id
#    * print 'tdItemId :' , tdItemId
#    * def lineId = $..lineId
#    * def esvParentId = $.esv.id
#    * print 'Esv id parent:' , esvParentId
#    * def tdId = $.id
#    * print 'Td id :' , tdId
#    * print response