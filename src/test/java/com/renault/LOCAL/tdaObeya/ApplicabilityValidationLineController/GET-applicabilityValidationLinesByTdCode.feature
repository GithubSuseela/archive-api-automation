Feature: As a tda client, I want to Get Applicability validation lines by td code

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Get Applicability validation lines by td code

    Given path '/api/v1/applicability-validation-details'
    And param tdCode = '<TdCode>'
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
    |TdCode|
    |3     |


