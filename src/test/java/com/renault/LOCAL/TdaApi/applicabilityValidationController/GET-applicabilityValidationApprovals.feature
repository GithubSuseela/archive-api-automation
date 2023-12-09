@ignore
#Tested by TDPTF-967
Feature: As a OneTD user, i want to retrieve applicability validation approvals

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Retrieve applicability validation approvals

    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And def appValNumber = karate.jsonPath(response, "$")[0]
#    And match appValNumber  ==  '#present'

    Given path '/api/v1/applicability-validations/', appValNumber.number ,'/approvals'
    When method get
    Then status 200
    And match response  ==  '#present'
