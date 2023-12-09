@ignore
#Tested by TDPTF-969
Feature: As a tda user, i want to get Get all not cancelled applicability validations

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: Get all not cancelled applicability validations
    Given path '/api/v1/applicability-validations'
    When method get
    Then status 200
    And match response  ==  '#present'

