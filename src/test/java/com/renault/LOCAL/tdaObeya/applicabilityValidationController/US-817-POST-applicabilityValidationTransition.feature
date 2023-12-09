Feature: As a tda client, I want to do transition on applicability validation

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 409 - Applicability validation transition

    # Create an applicability validation
    * def createAppVal = {"lines": [{"applicabilities": [{"tdCode": <tdCode1>, "type": <Type>}], "lineNumber": <lineNo>, "maturityLevel": <maturityLvl>, "reuseCategory": <reuseCat>}],"tdCode": <tdCode2>}
    Given path '/api/v1/applicability-validations'
    And request createAppVal
    When method post
    Then status 201
    And match response == '#present'
    And match response contains {status: "DRAFT"}
    * def applicabilityValidationNumber = $.applicabilityValidationNumber

    # POST Applicability validation Transition - Submit an AV with no approvers
    * def AppValTransition = { "transition": "SUBMIT", "comment": "Approve Draft AV without users"}
    * def expectedError = {"errorDescription":"All approvals of the AV must have at least one approver.","errors":[{"errorType":"functional","errorMessage":"Please fill in at least one approver per approval.","errorCode":"ERR_AV_SUBMIT_APPROVER_REQUIRED_IN_APPROVAL","errorLevel":"not allowed"}]}
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/transitions'
    And request AppValTransition
    When method post
    Then status 409
    And match response contains expectedError

    # Delete the created applicability validation
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber
    When method delete
    Then status 204

    Examples:
      |tdCode1|Type|lineNo|maturityLvl|reuseCat|tdCode2|
      |45|"FIRST_APP"|"3-48015"|"RTU"|"YELLOW"|3|
