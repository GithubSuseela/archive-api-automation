@ignore
#Tested by TDPTF-1171
Feature: As a TDA client, i want to get the company membership of the user from Arca

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Fetch the company membership of the user from Arca

    Given path '/api/v1/user-details'
    And param ipn = '<userIpn>'
    When method get
    Then status 200
    And match response  ==  '#present'


   Examples:
    |userIpn|
    |P099035|
