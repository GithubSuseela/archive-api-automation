Feature: As a tda client, I want to get all groups

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Get all groups

    #Service to get all groups
    Given path '/api/v1/groups'
    And param technicalDefinitionCode = <tdCode>
    And param type = <grpType>
    When method get
    Then status 200
    And match response == '#present'

    Examples:
      |tdCode|grpType|
      |3     |'PFL' |
      |3     |'APFL' |
      |3     |'' |