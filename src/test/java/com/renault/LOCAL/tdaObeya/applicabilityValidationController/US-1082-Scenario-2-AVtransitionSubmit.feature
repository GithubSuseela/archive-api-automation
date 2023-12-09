Feature: As a tda client, I want to Add check on status of the specific data for projects under applicability validation when I create/submit AV

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: AV - Transitions : Submit

    #  POST AV Transition - Submit - Specific data draft status functional error
    * def AppValTransition = { "transition": "SUBMIT", "comment": "Approve Draft AV without users"}
    * def expectedError = {"errorDescription":"1 line(s) have one of the following issues !","errors":[{"errorType":"functional","errorMessage":"Specific data for projects under applicability validation should be RTU","errorCode":"ERR_AV_CREATION_APPLICABILITY_LINES_VALID_STATUS","errorLevel":"not allowed"}]}
    Given path '/api/v1/applicability-validations/', <applicabilityValidationNumber> ,'/transitions'
    And request AppValTransition
    When method post
    Then status 409
    And match response contains expectedError

    Examples:
    |applicabilityValidationNumber|
    |373|