Feature: As a tda client, I want to Get applicability-validations by searching queryparam approver={ipn}

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - applicability-validations by searching queryparam approver={ipn}

    Given path '/api/v1/applicability-validations'
    And param approver = '<IPN>'
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
    |IPN|
    |p094235|
