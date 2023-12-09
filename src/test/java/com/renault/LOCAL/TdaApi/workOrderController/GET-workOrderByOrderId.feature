Feature: As a tda api client, I want to get the list of work order with a given status

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  Fetch the list of work order with a given status

    Given path '/api/v1/work-orders'
    And param status = '<Status>'
    When method get
    Then status 200
    And match response  ==  '#present'
#    And print response
    * def woResources = karate.jsonPath(response, "$.workOrderResources")[0]
    And print woResources
    * def workOrderId = woResources.workOrderId
    * print "Work Order Id =", workOrderId
#    And match each $.workOrderResources contains { nameEn:"#string", nameFr:"#string" }
#    * def woResources = karate.jsonPath(response, "$.workOrderResources[?(@.type=='CREATE_PART_NUMBER')]")[0]
#    * print woResources
#    And match woResources contains {nameEn: "#string", nameFr: "#string"}
    Given path '/api/v1/work-orders/', workOrderId
    And param orderid = workOrderId
    When method get
    Then status 200
    And match response  ==  '#present'
    * print response

    Examples:
    | Status |
    | OPEN |
#    | IN_PROGRESS |
#    | TO_BE_COMPLETED |
#    | CANCELLED |


