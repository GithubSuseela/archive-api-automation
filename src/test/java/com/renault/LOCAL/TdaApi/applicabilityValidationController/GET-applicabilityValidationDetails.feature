@ignore
#Tested by TDPTF-968
Feature: As a OneTD user, i want to get Applicability validation details by applicability validation number

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Get Applicability validation details by number

    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And def appValNumber = karate.jsonPath(response, "$")[0]
#    And match appValNumber  ==  '#present'

    Given path '/api/v1/applicability-validations/', appValNumber.number ,'/details'
    When method get
    Then status 200
    And match response  ==  '#present'
