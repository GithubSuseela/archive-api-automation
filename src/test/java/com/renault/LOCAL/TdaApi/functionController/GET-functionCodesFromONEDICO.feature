@ignore
#Tested by TDPTF-1010
Feature: As a tda api client, i want to get the list of function codes from One Dictionary

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch list of function codes from One Dictionary

    * def pageSize = 10
    Given path '/api/v1/functions/'
    And param codePattern = 'G*'
    And param page = 0
    And param size = pageSize
    When method get
    Then status 200
    And match response  ==  '#present'
