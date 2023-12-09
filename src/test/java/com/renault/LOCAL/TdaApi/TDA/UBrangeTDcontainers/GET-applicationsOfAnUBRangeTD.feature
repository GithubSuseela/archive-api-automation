Feature: As a tda client, I want to Get all the applications of an UB Range TD that have been configured for the Vehicles

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Get all the applications of an UB Range TD

    Given path '/api/v1/ub-range-technical-definitions/', '<tdCode>', '/applications'
    When method GET
    Then status 200
    And match response == '#present'

    Examples:
      |tdCode|
      |168|
      |174|