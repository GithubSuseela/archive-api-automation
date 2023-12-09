Feature: As a tda client, I want to Create or duplicate a TD Line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 201 - Create or duplicate a TD Line

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And def tdId = response.tdId

    Given path '/api/v1/technical-definitions/', tdId ,'/td-lines'
    And request ''
    When method post
    Then status 201
    And match response == '#present'
    * def tdItemId = $.tdItem.id
    * def lineId = $..lineId

    #    Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'
