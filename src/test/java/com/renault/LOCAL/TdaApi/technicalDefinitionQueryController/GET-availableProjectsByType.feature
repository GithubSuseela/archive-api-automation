@ignore
#Tested by TDPTF-1045
Feature: As a tda api client, I want to get the available projects by type

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  Fetch available projects by type

    Given path '/api/v0/technical-definitions'
    And param type = '<TYPE>'
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
    |TYPE|
    |PLATFORM|
    |VEHICLE|

