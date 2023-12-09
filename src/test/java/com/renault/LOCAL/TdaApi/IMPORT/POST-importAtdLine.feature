Feature: As a tda api client, I want to create or update Td Line with provided line data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 201 - create or update Td Line with provided line data

    * def reqData =
    """
    {
      "lineColumnDatas": [{"columnKey": "SOURCE_ID", "value": "403",
                           "columnKey": "TD_SOURCE", "value": "IMPTEST",
                          }]
    }
    """
    * def resp1 = {"lineUpdated": {"lineNumber": "#string", "technicalDefinitionCode": "#number"}}
    * def resp2 = {"error": "Not Found"}
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/line-import'
    And request reqData
    When method post
    Then status <status>
    And match response  ==  '#present'
#    * print response
    And match response contains <expected>

    Examples:
      | tdCode |status|expected|
      | 3 |201        |resp1   |
      |   |404        |resp2   |

