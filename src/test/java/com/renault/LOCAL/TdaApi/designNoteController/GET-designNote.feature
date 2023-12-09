@ignore
#Tested by TDPTF-974
Feature: As a OneTD user, i want to get the list of design notes

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Design notes list
    Given path '/api/v1/design-notes'
    When method get
    Then status 200
    And match response  ==  '#present'
