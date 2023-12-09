Feature: As a tda client, I want to update tdItem

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 200 - update tdItem
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
    * def platformTdItemId = $.tdItem.id
    * print 'platform td item id:', platformTdItemId
    #    PATCH - update the TDitem
    * def req =
      """
      {
        "makeOrBuy": {
          "value": <makeOrBuy>
        },
        "forecastDiversity": {
          "value": <forecastDiv>
        },
        "userComment": {
          "value": <Comment>
        },
        "updatedByIpn": {
        "value": "z014082"
      }
      }
      """
    Given path '/api/v1/technical-definition-items/', platformTdItemId
    And request req
    When method patch
    Then status 200
#    And match response == '#present'
#    * print response
    And match response contains {"makeOrBuy": "BUY_WITHOUT_CONTRACT"}
    And match response contains {"forecastDiversity": "BJA"}
    #    Delete the created line
    Given path '/api/v1/technical-definition-lines/', platformTdItemId
    When method delete
    Then status 204
    And match response == '#present'

    Examples:
    |makeOrBuy|Comment|forecastDiv|
    |"BUY_WITHOUT_CONTRACT"|"Test Comment"|"BJA"|
