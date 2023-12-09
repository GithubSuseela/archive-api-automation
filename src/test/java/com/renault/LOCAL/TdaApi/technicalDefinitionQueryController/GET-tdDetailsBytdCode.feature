@ignore
#Tested by TDPTF-1048
Feature: As a tda api client, I want to get the TD details by tdCode

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the TD details by tdCode

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
    * def pageSize = 10


    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    And assert response.code == platform.code
