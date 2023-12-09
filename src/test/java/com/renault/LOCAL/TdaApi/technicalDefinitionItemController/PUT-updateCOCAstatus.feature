Feature: As a tda client, I want to COCA Status

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PUT - 204 - Update COCA Status

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

    #Update COCA status
    * def tdItemCocaStatusReqData =
      """
      {
          "cocaStatus": <cocaStatus>
       }
      """
    Given path '/api/v1/technical-definition-items/', platformTdItemId, '/coca-status'
    And request tdItemCocaStatusReqData
    When method put
    Then status 204
    * print 'change coca to BLUE for platform td line is ok'

    # Delete the created line
    Given path '/api/v1/technical-definition-lines/', platformTdItemId
    When method delete
    Then status 204
    * print 'The created line has been deleted'

    Examples:
      |cocaStatus|
      |'BLUE'|
      |'GREEN'|
      |'PALE_G'|

