Feature: As a tda api client, I want to validate the error message while creating the release order

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 404 - Error Validation (TD Not Found / or Td not allowed)

#   Example applied td is invalid
    * def tdNotFoundError =
    """
    {
      "errors": [
        {
          "errorCode": "TD_NOT_FOUND",
          "errorMessage": "The specified TD could not be found",
          "errorLevel": "error",
          "errorType": "functional"
        }
      ],
      "errorDescription": "TD_NOT_FOUND"
    }
    """
#   Example applied td is different
    * def tdNotAllowedError =
    """
    {
      "errors": [
        {
          "errorCode": "APPLIED_TD_CODE_NOT_ALLOWED",
          "errorMessage": "Applied TD Code must not be a Transversal TD Code",
          "errorLevel": "error",
          "errorType": "functional"
        }
      ],
      "errorDescription": "CONFLICT"
    }
    """
    * def reqData =
    """
    {
      "releaseOrderDetails": {
        "sourceTechnicalDefinitionCode": <srcTdCode> ,
        "designNote": {
          "information": {
            "designNotekind": {
              "code": "PRODUCTION"
            },
            "designNoteClass": {
              "code": "PROVISIONAL"
            }
          },
          "documentation": {
            "themeEn": "My wonderful design note title"
          }
        },
        "associatedLines": [
          {
            "lineIdentity": {
              "technicalDefinitionCode": <TdCode>,
              "lineNumber": "3-116559"
            },
            "comment": "My wonderful line comment giving information about the BOM impact type"
          }
        ]
      },
      "requestedBy": "z014082"
    }
    """
    Given path '/api/v1/release-orders'
    And request reqData
    When method post
    Then status <status>
    And match response  ==  '#present'
#    * print response
    And match response contains <expected>

    Examples:
      | srcTdCode |TdCode|status|expected|
      |0          |3     |404        |tdNotFoundError|
      |3          |3     |409        |tdNotAllowedError|

