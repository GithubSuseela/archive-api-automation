@ignore
#Tested by TDPTF-964
Feature: As a tda user, I want to get the history of specific data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 Query for lines to fetch the history of specific data

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
    And match platform == '#present'

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    And def tdId = response.tdId
    And def createdAt = response.createdAt

    Given path '/api/v1/technical-definitions/', tdId ,'/project-applicabilities'
    And param code = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    And def resp = karate.jsonPath(response, "$.available")[0]
    And def appTdId = resp.id

    Given path '/api/v1/technical-definitions/', appTdId ,'/applicability/history'
    And param since = createdAt
    And configure readTimeout = 100000
    When method get
    Then status 200
    And match response  ==  '#present'

    Given path '/api/v1/technical-definitions/', appTdId ,'/specific-data/history'
    And param since = createdAt
    And configure readTimeout = 100000
    When method get
    Then status 200
    And match response  ==  '#present'

