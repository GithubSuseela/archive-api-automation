
Feature: As a tda user, i want to get the list of design notes

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch the list of Design Notes

    Given path '/design-notes'
    When method get
    Then status 200
#    * print response




