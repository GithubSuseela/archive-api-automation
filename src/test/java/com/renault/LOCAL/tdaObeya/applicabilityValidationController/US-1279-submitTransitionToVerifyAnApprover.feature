Feature: As a tda client, I want to check in the applicability validation on SUBMIT transition to verify that there is at least an approver per group and per approval

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 409 - verify that there is at least an approver per group and per approval

    * def req = {"transition": "SUBMIT", "comment": "verify there is at least an approver"}
    * def resp = {"errors": [{"errorCode": "ERR_AV_SUBMIT_APPROVER_REQUIRED_IN_APPROVAL", "errorMessage": "Please populate at least an approver by group for each approval.", "errorLevel": "not allowed", "errorType": "functional"}], "errorDescription": "Please populate at least an approver by group for each approval."}
    Given path '/api/v1/applicability-validations/', <applicabilityValidationNumber> ,'/transitions'
    And request req
    When method post
    Then status 409
    And match response == resp

    Examples:
      |applicabilityValidationNumber|
      |405|