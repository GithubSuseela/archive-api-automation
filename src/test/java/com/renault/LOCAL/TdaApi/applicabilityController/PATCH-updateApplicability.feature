@ignore
#Tested by TDPTF-909-wrong test in jira
Feature: As a tda user, I want to get the history of Applicability data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


Scenario: GET - 200 - Query for lines to get the list of application warnings
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]
    And def pageSize = 10

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def tdId = response.id

    Given path '/api/v1/technical-definitions/', tdId , '/application-warnings'
    When method get
    Then status 200
    And match response  ==  '#present'
