Feature: As a tda client, I want to Remove an application for an UB Range TD

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: DELETE - 204 - Remove an application for an UB Range TD

    # create application for UB range
    * def putReq =
    """
    {
      "isApprobationRequired": true
    }
    """
    Given path '/api/v1/ub-range-technical-definitions/', '<tdCode>', '/applications', '<toTdCode>'
    And request putReq
    When method PUT
    Then status 204
    And match response == '#present'
    #Remove an application for an UB Range TD
    Given path '/api/v1/ub-range-technical-definitions/', '<tdCode>', '/applications', '<toTdCode>'
    When method DELETE
    Then status 204
    And match response == '#present'

    Examples:
      |tdCode|toTdCode|
      |174|12        |


