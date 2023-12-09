@ignore
#Tested by TDPTF-1038
Feature: As a tda api client, I want to get specific data by platformId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch specific data by platformId

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[10]

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And def platformTdId = response.tdId

    Given path '/api/v1/technical-definitions/', platformTdId ,'/specific-data'
    When method get
    And configure readTimeout = 10000
    Then status 200
    And match response  ==  '#present'