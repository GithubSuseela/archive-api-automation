Feature: As a tda client, I want to raise functional error when COCA is not applicable (grey) and Line status is "published" with applicabilities not eligible for approval flow

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 409 - Raise functional error when COCA is not applicable (grey) and Line status is "published"

    # Scenario-1 : Create applicability validation - COCA: Grey and Status: PUBLISHED
    * def createAppVal1 = {"lines":[{"applicabilities":[{"tdCode": 45, "type": "FIRST_APP"}], "lineNumber": "3-47401", "maturityLevel": "PUBLISHED", "reuseCategory": "GREY"}],"tdCode": 3}
    * def expected1 = {"errorType":"functional","errorMessage":"Lines should have COCA different than grey color","errorCode":"BAD_REQUEST","errorLevel":"error"}
    # Scenario-2 : Create applicability validation - COCA: Other than Grey, Status: PUBLISHED and no applicability validation flow is enabled for any project
#    * def createAppVal2 = {"lines":[{"applicabilities":[{"tdCode": 45, "type": "FIRST_APP"}], "lineNumber": "3-4507", "maturityLevel": "PUBLISHED", "reuseCategory": "GREEN"}],"tdCode": 3}
#    * def expected2 = {"errorType":"functional","errorMessage":"Lines are not eligible for applicability validation","errorCode":"BAD_REQUEST","errorLevel":"error"}
    # Scenario-3 : Create applicability validation - COCA: Grey , Status: DRAFT and Project not applied
    * def createAppVal3 = {"lines":[{"applicabilities":[{"tdCode": 45, "type": "FIRST_APP"}], "lineNumber": "3-48618", "maturityLevel": "DRAFT", "reuseCategory": "GREY"}],"tdCode": 3}
    * def expected3 = {"errorType":"functional","errorMessage":"Lines should have COCA different than grey color","errorCode":"BAD_REQUEST","errorLevel":"error"}
    # Scenario-4 : Create applicability validation - COCA: GREEN , Status: DRAFT and Project not applied
    * def createAppVal4 = {"lines":[{"applicabilities":[{"tdCode": 45, "type": "FIRST_APP"}], "lineNumber": "3-48618", "maturityLevel": "DRAFT", "reuseCategory": "GREEN"}],"tdCode": 3}
    * def expected4 = {"errorDescription":"1 line(s) have one of the following issues !","errors":[{"errorType":"functional","errorMessage":"Status of the lines should be Ready To Use or Published.\nPlease select or update only lines allowed for validation.","errorCode":"ERR_AV_CREATION_LINES_VALID_STATUS","errorLevel":"not allowed"}]}
    Given path '/api/v1/applicability-validations'
    And request <createAppVal>
    When method post
    Then status <Status>
    And match response == '#present'
    And match response contains '<expected>'

    Examples:
      |createAppVal|Status|expected|
      |createAppVal1|400|#(expected1)|
#      |createAppVal2|400|#(expected2)| --  need to check for test data
      |createAppVal3|400|#(expected3)|
      |createAppVal4|409|#(expected4)|



#    # POST Applicability validation Transition - Submit an AV with no approvers
#    * def AppValTransition = { "transition": "SUBMIT", "comment": "Approve Draft AV without users"}
#    * def expectedError = {"errorDescription":"All approvals of the AV must have at least one approver.","errors":[{"errorType":"functional","errorMessage":"Please fill in at least one approver per approval.","errorCode":"ERR_AV_SUBMIT_APPROVER_REQUIRED_IN_APPROVAL","errorLevel":"not allowed"}]}
#    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/transitions'
#    And request AppValTransition
#    When method post
#    Then status 409
#    * print response
#    And match response contains expectedError
#
#    # Delete the created applicability validation
#    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber
#    When method delete
#    Then status 204
