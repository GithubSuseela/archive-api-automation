@ignore
#Tested by TDPTF-1011
Feature: As a tda api client, i want to find Function GP in One Dictionary

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - To find Function GP in One Dictionary

    Given path '/api/v1/functions/'
    And param codePattern = 'G*'
    When method get
    And configure readTimeout = 100000
    Then status 200
    And def functions =  karate.jsonPath(response, "$")[0]

    Given path '/api/v1/functions/'
    And param code = functions.functionCode
    When method get
    Then status 200
    And match response  ==  '#present'
