Feature: As a tda client, I want to Add applicability validation approval items

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Add applicability validation approval items

    # Create an applicability validation
    * def createAppVal =
    """
          {
            "lines": [
              {
                "applicabilities": [
                  {
                    "tdCode": <tdCode1>,
                    "type": <Type>
                  }
                ],
                "lineNumber": <lineNo>,
                "maturityLevel": <maturityLvl>,
                "reuseCategory": <reuseCat>
              }
            ],
            "tdCode": <tdCode2>
          }
     """
    Given path '/api/v1/applicability-validations'
    And request createAppVal
    When method post
    Then status 201
    And match response == '#present'
    And match response contains {status: "DRAFT"}
    * def applicabilityValidationNumber = $.applicabilityValidationNumber

    #Get applicability validation approvals
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/approvals'
    When method get
    Then status 200
    * def approvalNum = $.applicabilityValidationApprovals[0].approvalNumber

    #POST - Add applicability validation approval items
    * def approvalItemReqData =
    """
    {
      "approver": "Z014082",
      "groupNumber": 1
    }
    """

    Given path '/api/v1/applicability-validations/' , applicabilityValidationNumber ,'/approvals/' , approvalNum ,'/approval-items'
    And request approvalItemReqData
    When method post
    Then status 201
    And match response  ==  '#present'
    * def applicabilityValidationApprovalItems =
    """
    {
      "approvalItemNumber": "#number",
      "approver": "#string",
      "groupNumber": "#number",
      "status": "#string",
     }
    """
#  "approverValidationOrder": "#number",
#  "groupValidationOrder": "#number",
#  "comment":"#string",
#  "completionDate": "#string"
    And match response contains applicabilityValidationApprovalItems

    # Delete the created applicability validation
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber
    When method delete
    Then status 204

    Examples:
      |tdCode1|Type|lineNo|maturityLvl|reuseCat|tdCode2|
      |45|"FIRST_APP"|"3-42486"|"RTU"|"GREEN"|3|
