Feature: As a tda api client, I want to get the list of work order with a given status

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the list of work order with a given status

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]
    * def vehicle = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE')]")[0]
    * match platform == '#present'
    * match vehicle == '#present'
    * print response
    * print platform
    * print vehicle
    Given path '/api/v1/technical-definitions/code/', 3
    When method get
    Then status 200
    * print response
    * def platformTdId = response.id
    * print platformTdId
    * match platformTdId == '#present'