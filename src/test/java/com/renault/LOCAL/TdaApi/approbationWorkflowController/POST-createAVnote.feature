Feature: As a tda client, I want to create AV note in TDA (Add New endpoint)

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 201 - create AV note in TDA

    * def RequestData =
    """
      {
        "technicalDefinitions": [
          { "tdCode": 19 }
        ],
        "lines": [
          { "lineNumber": "3-1989" }
        ],
        "tdCode": 3
      }
    """
    Given path '/api/v1/applicability-validations'
    And request RequestData
    When method post
    Then status 201
    And match response == '#present'
    * print response

#    Examples:
#      |ApprobationType|ApprobationNumber|ApprobationStatus|ProposalNumber|ProposalStatus|TDCode|LineNumbers|ProposalType|
#      |'APPLICABILITY_VALIDATION'|1       |'PROPOSED'     |1            |'PROPOSED'     |3     |["3-230"]|'APPLICABILITY'|
#      |'APPLICABILITY_VALIDATION'|1       |'PROPOSED'     |1            |'PROPOSED'     |3     |["3-230"]|'PLATFORM_LINE'|
#      |'APPLICABILITY_VALIDATION'|1       |'PROPOSED'     |1            |'PROPOSED'     |3     |["3-230"]|'APPLICABILITY_REMOVAL'|