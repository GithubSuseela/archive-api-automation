Feature: As a tda client, I want to check the Group Validation Order is respected in the Approval Transitions

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - Group Validation Order is respected in the Approval Transitions

# Prerequisite - A group exists with two users having group validation order 1 (User: z014332)  and 2 (user: z014082)

#    * def grpId = '45aa52ad-5cbf-4882-9107-c7137c9c8054'
    * def grpNo = 34

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

    #Change the status to Pending
    * def statusTransitionReq = {"transition": "SUBMIT", "comment": "Submitting the Draft AV"}
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/transitions'
    And request createAppVal
    When method post
    Then status 204
#    And match response == '#present'


    #Get applicability validation approvals
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/approvals'
    When method get
    Then status 200
    * def approvalNum = $.applicabilityValidationApprovals[0].approvalNumber

    #POST - Add applicability validation approval items (Here the approver has the Group Validation order as '2')
    * def approvalItemReqData1 = {"approver": "Z014082", "groupNumber": #(grpNo)}
    * def approvalItemReqData2 = {"approver": "Z014332", "groupNumber": #(grpNo)}

    Given path '/api/v1/applicability-validations/' , applicabilityValidationNumber ,'/approvals/' , approvalNum ,'/approval-items'
    And request approvalItemReqData1
    When method post
    Then status 201
    And match response  ==  '#present'
    * def approvalItemNo = response.approvalItemNumber

    Given path '/api/v1/applicability-validations/' , applicabilityValidationNumber ,'/approvals/' , approvalNum ,'/approval-items'
    And request approvalItemReqData2
    When method post
    Then status 201
    And match response  ==  '#present'

    * def transitionAPPROVE = {"transition": "APPROVE", "comment": "APPROVE check"}
    * def transitionREJECT = {"transition": "REJECT", "comment": "REJECT check"}
    * def transitionREOPEN = {"transition": "REOPEN", "comment": "REOPEN check"}
    * def transitionSUBMIT = {"transition": "SUBMIT", "comment": "SUBMIT check"}

    * def expected1 = {"errors": [{"errorCode": "ERR_GROUP_ORDER_IN_APPLICABILITY_APPROVAL_NOT_RESPECTED", "errorMessage": "The transition APPROVE is not accepted for the approval item, because group order is not respected in the flow", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "The transition APPROVE is not accepted for the approval item, because group order is not respected in the flow"}
    * def expected2 = {"errors": [{"errorCode": "ERR_GROUP_ORDER_IN_APPLICABILITY_APPROVAL_NOT_RESPECTED", "errorMessage": "The transition REJECT is not accepted for the approval item, because group order is not respected in the flow", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "The transition REJECT is not accepted for the approval item, because group order is not respected in the flow"}
    * def expected3 = {"errors": [{"errorCode": "ERR_GROUP_ORDER_IN_APPLICABILITY_APPROVAL_NOT_RESPECTED", "errorMessage": "The transition REOPEN is not accepted for the approval item, because group order is not respected in the flow", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "The transition REOPEN is not accepted for the approval item, because group order is not respected in the flow"}
    * def expected4 = {"errors": [{"errorCode": "ERR_GROUP_ORDER_IN_APPLICABILITY_APPROVAL_NOT_RESPECTED", "errorMessage": "The transition SUBMIT is not accepted for the approval item, because group order is not respected in the flow", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "The transition SUBMIT is not accepted for the approval item, because group order is not respected in the flow"}

    Given path '/api/v1/applicability-validations/' , applicabilityValidationNumber ,'/approvals/' , approvalNum ,'/approval-items/', approvalItemNo ,'/transitions'
    And request <transitionReqData>
    When method post
    Then status 400
    And match response  ==  '#present'
    And match response == <expected>


    # Delete the created applicability validation
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber
    When method delete
    Then status 204

    Examples:
      |tdCode1|Type|lineNo|maturityLvl|reuseCat|tdCode2|transitionReqData|expected|
      |45|"FIRST_APP"|"3-42486"|"RTU"|"GREEN"|3|transitionAPPROVE|expected1|
      |45|"FIRST_APP"|"3-42486"|"RTU"|"GREEN"|3|transitionREJECT|expected2|
#      |45|"FIRST_APP"|"3-42486"|"RTU"|"GREEN"|3|transitionREOPEN|expected3|
#      |45|"FIRST_APP"|"3-42486"|"RTU"|"GREEN"|3|transitionSUBMIT|expected4|