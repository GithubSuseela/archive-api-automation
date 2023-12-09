Feature: As a tda client, I want to Get Project Applicability

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Get Project Applicability
    #   POST - Create a new TD line
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]
    * match platform == '#present'

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    * def platformId = response.id
    * match platformId == '#present'
    #  Get Project Applicability grouped by Applied and Available
    Given path '/api/v1/technical-definitions/', platformId, '/project-applicabilities'
    When method get
    Then status 200
    * match response == '#present'


