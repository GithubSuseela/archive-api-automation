Feature: As a tda client, I want to Add check on status of the specific data for projects under applicability validation when I create/submit AV

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - Create Applicability Validation

    # POST /applicability_validation - Specific data status functional error
    * def createAppVal = {"lines": [{"applicabilities": [{"tdCode": <tdCode1>, "type": <Type>}], "lineNumber": <lineNo>, "maturityLevel": <maturityLvl>, "reuseCategory": <reuseCat>}], "tdCode": <tdCode2>}
    * def errExpected1 = {"errorDescription":"1 line(s) have one of the following issues !","errors":[{"errorType":"functional","errorMessage":"Specific data for projects under applicability validation should be RTU","errorCode":"ERR_AV_CREATION_APPLICABILITY_LINES_VALID_STATUS","errorLevel":"not allowed"}]}
    Given path '/api/v1/applicability-validations'
    And request createAppVal
    When method post
    Then status 409
    And match response == errExpected1

    Examples:
    |tdCode1|Type|lineNo|maturityLvl|reuseCat|tdCode2|
    |45|"FIRST_APP"|"3-48755"|"RTU"|"GREEN"|3|