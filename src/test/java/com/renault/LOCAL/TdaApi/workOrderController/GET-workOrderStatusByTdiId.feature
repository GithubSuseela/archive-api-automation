Feature: As a tda api client, I want to get Work Orders Statuses By TD Lines

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  Fetch the list of Work Orders Statuses By TD Lines

    # Get Td item id
    Given path '/api/v1/work-orders'
    And param status = '<Status>'
    When method get
    Then status 200
    And match response  ==  '#present'
    * def woResources = karate.jsonPath(response, "$.workOrderResources")[0]
    * def tdiId = woResources.tdItemId
    * print 'TdiId:', tdiId
    # Get WO resource by TdItemId
    Given path '/api/v1/work-orders/status'
    And param tdiIds = tdiId
    When method get
    Then status 200
    And match response  ==  '#present'
    And match $..tdLineWorkOrderStatuses contains ("tdiId": '#(TdiId)')
    Examples:
    | Status |
    | OPEN |
    | IN_PROGRESS |



