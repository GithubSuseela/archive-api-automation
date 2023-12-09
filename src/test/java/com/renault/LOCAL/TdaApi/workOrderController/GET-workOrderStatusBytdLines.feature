@ignore
#Tested by TDPTF-1162
Feature: As a tda api client, I want to get the work order status for given TD lines

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the work order status for given TD lines
    Given path '/api/v1/work-orders/status'
    And param tdiIds = ''
    When method get
    Then status 200
    And match response  ==  '#present'
