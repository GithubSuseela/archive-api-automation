Feature: As a tda client, I want to Set an application for an UB Range TD

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PUT - 204 - Set an application for an UB Range TD

    * def expected1 = '#present'

    * def expected2 =
    """
    {
      "errors": [
        {
          "errorCode": "BAD_REQUEST",
          "errorMessage": "It is possible to create applicability link only between UB_RANGE and PROJECT TD",
          "errorLevel": "error",
          "errorType": "functional"
        }
      ],
      "errorDescription": "BAD_REQUEST"
    }
    """
    * def expected3 =
    """
    {
      "errors": [
        {
          "errorCode": "BAD_REQUEST",
          "errorMessage": "It is not possible to create applicability link for a technical definition which is not UB_RANGE",
          "errorLevel": "error",
          "errorType": "functional"
        }
      ],
      "errorDescription": "BAD_REQUEST"
    }
    """
    * def putReq =
    """
    {
      "isApprobationRequired": true
    }
    """
    Given path '/api/v1/ub-range-technical-definitions/', '<tdCode>', '/applications', '<toTdCode>'
    And request putReq
    When method PUT
    Then status <status>
    And match response == <expected>

    Examples:
      |tdCode|toTdCode|status|expected|
      |168|12        |204    |expected1|
      |168|145       |400    |expected2|
      |115|3         |400    |expected3|
