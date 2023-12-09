Feature: As a tda client, I want to create applicability validation approvals

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Create applicability validation approvals

    * def createAppVal =
    """
      {
        "tdCode": <tdCode1>,
        "applicabilityValidationApprovals": [
          {
            "approverGroups": [
              {
                "groupType": <grpType>,
                "groupValidationOrder": <grpValidOrder>
              }
            ],
            "regroupCode": <reGrpCode>,
            "tdCode": <tdCode2>,
            "type": <type>,
            "status": <status>,
            "lines": [
              {
                "lineNumber": <lineNo>
              }
            ]
          }
        ]
      }
     """
    * def expected =
    """
    {
      "applicabilityValidationNumber": "#number",
      "status": <status>,
      "createdBy": "#string",
      "creationDate": "#string",
      "srcTdCode": <tdCode1>
    }
    """
    Given path '/api/v1/applicability-validations'
    And request createAppVal
    When method post
    Then status 201
    And match response == '#present'
    And match response contains expected

    Examples:
    |tdCode1|grpType|grpValidOrder|reGrpCode|tdCode2|type|status|lineNo|
    |3|"PFL"|1|"COCA_BLUE_RED_PUBLISHED"|45|"PLATFORM_LINE"|"DRAFT"|"3-42486"|
#    |45|"FIRST_APP"|"3-48791"|"RTU"|"GREEN"|3|