@ignore
#Tested by TDPTF-1017
Feature: As a tda api client, I want to fetch the history of applicability status

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 Fetch the history of applicability status by applicabilityId

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And def tdId = response.tdId

    Given path '/api/v1/technical-definitions/', tdId ,'/project-applicabilities'
    And param code = platform.code
    When method get
    Then status 200
    And def resp = karate.jsonPath(response, "$.applied")[0]
    And def appTdId = resp.id

    Given path '/api/v1/technical-definitions/applicabilities/', appTdId
    When method get
    Then status 200
    And match response  ==  '#present'

