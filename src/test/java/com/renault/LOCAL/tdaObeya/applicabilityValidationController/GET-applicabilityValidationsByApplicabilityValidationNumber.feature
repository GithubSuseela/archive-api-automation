Feature: As a tda client, I want to Get applicability validation by number

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Get applicability validation by number

    # Get the applicability validation number
    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And match response  ==  '#present'
    * def applicabilityValidationNumber = $.applicabilityValidations[0].applicabilityValidationNumber

    # Get applicability validation by number
    Given path '/api/v1/applicability-validations/' , applicabilityValidationNumber
    When method get
    Then status 200
    And match response  ==  '#present'
    And match $.applicabilityValidationNumber == applicabilityValidationNumber

