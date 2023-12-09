@ignore
#Tested by TDPTF-970
Feature: As a OneTD user, i want to get the Applicability validation lines by td code

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:   Get Applicability validation lines by td code

    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And def appValidations = karate.jsonPath(response, "$")[0]
#    And match appValidations  ==  '#present'

    Given path '/api/v1/applicability-validation-details'
    And param tdCode = appValidations.srcTdCode
    When method get
    Then status 200
    And match response  ==  '#present'
