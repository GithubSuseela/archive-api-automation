Feature: As a tda client, I want to Get the part structure components associated to the Td Line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  #noinspection GherkinBrokenTableInspection
  Scenario Outline: GET - 200 - Part structure components associated to the Td Line

    # Get the TD Code
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]
    * def tdCode = platform.code
    And print 'Td Code:', tdCode

    # Get the Line Id
    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id
#    And match platformId == '#present'

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And match response == '#present'
    * def tdLines = karate.jsonPath(response, "$.content[?(@.ts.tsvItem.partKind=='ASSEMBLY')]")[0]
#    * print tdLines
    * def lineId = karate.jsonPath(tdLines, "esv.lineId")
    And print 'Line Id:', lineId

    # Get the part structure components and verify the error messages
    * def resp1 =
    """
    {
      "errorDescription": "TD_LINE_NOT_FOUND",
      "errors": [
        {
          "errorType": "functional",
          "errorMessage": "The specified TD Line could not be found",
          "errorCode": "TD_LINE_NOT_FOUND",
          "errorLevel": "error"
        }
      ]
    }
    """
    * def resp2 =
    """
    {
      "errorDescription": "TD_NOT_FOUND",
      "errors": [
        {
          "errorType": "functional",
          "errorMessage": "The specified TD could not be found",
          "errorCode": "TD_NOT_FOUND",
          "errorLevel": "error"
        }
      ]
    }
    """
    Given path '/api/v1/technical-definitions/', <TdCode> ,'/lines/', <LineId> ,'/part-structure-components'
    And param requestedBy = <reqBy>
    When method get
    Then status <Status>
    And match response == <expected>

    Examples:
    |TdCode|LineId|Status|expected|reqBy|
    |tdCode|lineId|200|'#present' |'z014082'|
    |tdCode|123456|404|resp1      |'z014082'|
    |0|lineId|404|resp2           |'z014082'|
