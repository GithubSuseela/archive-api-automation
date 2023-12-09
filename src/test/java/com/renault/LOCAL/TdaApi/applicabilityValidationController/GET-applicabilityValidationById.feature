@ignore
#Tested by TDPTF-983
Feature: As a OneTD user, i want to get the applicability validation by id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Get applicability validation by id

    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And def appValNumber = karate.jsonPath(response, "$")[0]
#    And match appValNumber  ==  '#present'
    And def number = appValNumber.number

    Given path '/api/v1/applicability-validations/'
    And param applicabilityValidationNumber = number
    When method get
    Then status 200
    And match response  ==  '#present'
