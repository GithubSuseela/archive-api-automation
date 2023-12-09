Feature: As a tda client, I want to Delete applicability validation approval item

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: DELETE - 204 - Delete applicability validation approval item

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
    * def approvalItemNum = response.approvalItemNumber

    # Delete applicability validation approval item
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/approvals/', approvalNum ,'/approval-items/', approvalItemNum
    When method delete
    Then status 204

    # verify deleted applicability validation approval item is not present
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/approvals'
    When method get
    Then status 200
    * match $.applicabilityValidationApprovals !contains "approvalItems:"


    # Delete the created applicability validation
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber
    When method delete
    Then status 204

    # verify deleted applicability validation is not present
    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And match response  ==  '#present'
    And match $..applicabilityValidationNumber != applicabilityValidationNumber

    Examples:
      |tdCode1|Type|lineNo|maturityLvl|reuseCat|tdCode2|
      |45|"FIRST_APP"|"3-42486"|"RTU"|"GREEN"|3|