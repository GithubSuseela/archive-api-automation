@ignore
#Tested by TDPTF-1058
Feature: As a tda api client, I want to get the number of work orders based on a status filter

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  Fetch the number of work orders based on a status filter
    Given path '/api/v1/work-orders/count'
    And param status = '<Status>'
    When method get
    Then status 200
    And match response  ==  '#present'

    Examples:
      | Status |
      | OPEN |
      | IN_PROGRESS |
      | TO_BE_COMPLETED |
      | CANCELLED |
