@ignore
#Tested by TDPTF-963
Feature: As a tda user, I want to get the history of lines based on technical definition id and a date

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - History of lines based on tdId and date-time

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
    And def resp = karate.jsonPath(response, "$.applied")[0]
    And def appTdId = resp.id


    Given path '/api/v1/technical-definitions/', appTdId ,'/lines/history'
    And param since = createdAt
    And param tdType = 'PLATFORM'
    And configure readTimeout = 100000
    When method get
    Then status 200
    And match response  ==  '#present'

