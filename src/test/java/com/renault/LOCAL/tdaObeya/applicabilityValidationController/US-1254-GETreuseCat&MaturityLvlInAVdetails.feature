Feature: As a tda client, I want to view lines associated to each approval, send the Reuse Category and Maturity level when I get the details of my applicability validation

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Get the Reuse Category and Maturity level in my applicability validation details

    # Get the applicability validation number
    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And match response  ==  '#present'
    * def applicabilityValidationNumber = $.applicabilityValidations[0].applicabilityValidationNumber

    # Get applicability validation by number and verify Reuse Category and Maturity level
    Given path '/api/v1/applicability-validations/', applicabilityValidationNumber ,'/details'
    When method get
    Then status 200
    And match response  ==  '#present'
    And match each $.applicabilities contains {"reuseCategory" : '#string',  "maturityLevel" : '#string'}