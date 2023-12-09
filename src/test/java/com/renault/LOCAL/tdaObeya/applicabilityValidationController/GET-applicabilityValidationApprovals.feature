Feature: As a tda client, I want to retrieve applicability validation approvals

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 Retrieve applicability validation approvals

    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And match response  ==  '#present'
    * def applicabilityValidationNumber = $.applicabilityValidations[0].applicabilityValidationNumber
    * print applicabilityValidationNumber

    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/approvals'
    And param applicabilityValidationNumber = applicabilityValidationNumber
    When method get
    Then status 200
    And match response  ==  '#present'

