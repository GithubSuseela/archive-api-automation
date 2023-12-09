Feature: As a tda client, I want to Get all not cancelled applicability validation

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Get all not cancelled applicability validation

    Given path '/api/v1/applicability-validations'
    And param approver = <IPN>
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
      |IPN|
      | "p094235" |
      |null       |


