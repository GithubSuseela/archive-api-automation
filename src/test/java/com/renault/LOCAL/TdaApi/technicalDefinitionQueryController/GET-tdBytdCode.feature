@ignore
#Tested by TDPTF-1047
Feature: As a tda api client, I want to get the TD by its code

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the TD by its code

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
    * def pageSize = 10

    Given path '/api/v1/technical-definitions/code', platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    And assert response.code == platform.code

