Feature: As a tda client, I want to Return the properties of an UB Range TD

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Return the properties of an UB Range TD

    * def expected =
    """
    {
      "ubRangeTechnicalDefinition": {
        "tdCode": <tdCode>,
        "name": #string,
        "company": #string,
        "comment": #string,
        "isEligibleForDigitalMockUp": #boolean,
        "createdAt": #string,
        "createdBy": #string,
        "modifiedAt": #string,
        "modifiedBy": #string,
        "ubRangeProject": {
          "familyCode": #string,
          "rangeName": #string
        },
        "businessProject": {
          "projectCode": #string,
          "projectName": #string
        },
        "status": {
          "isActive": #boolean
        }
      }
    }
    """
    Given path '/api/v1/ub-range-technical-definitions/', <tdCode>
    When method GET
    Then status 200
    And match response == '#present'
    And match response == expected

    Examples:
      |tdCode|
      |168|
      |174|