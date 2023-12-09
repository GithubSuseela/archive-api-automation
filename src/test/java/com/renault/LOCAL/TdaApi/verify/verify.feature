Feature: As a tda api client, i want the environment to be fully functional.

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario: Can query for lines for a platform and vehicle TD
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]
    * def vehicle = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE')]")[0]
    * match platform == '#present'
    * match vehicle == '#present'

    * def pageSize = 10

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    * def platformId = response.id
    * match platformId == '#present'

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines';
    And param page = 0
    And param size = pageSize
    When method get
    Then status 200
    * match response.content == '#present'
    * assert response.content.length == pageSize

    Given path '/api/v1/technical-definitions/code/', vehicle.code
    When method get
    Then status 200
    * def vehicleId = response.id
    * match vehicleId == '#present'

    Given path '/api/v1.1/technical-definitions/', vehicleId, '/technical-definition-lines';
    And param page = 0
    And param size = pageSize
    When method get
    Then status 200
    * match response.content == '#present'
    * assert response.content.length == pageSize