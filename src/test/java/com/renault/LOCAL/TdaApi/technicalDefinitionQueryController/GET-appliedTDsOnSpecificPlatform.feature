@ignore
#Tested by TDPTF-1044
Feature: As a tda api client, I want to find appliedTD(s) on specific platform

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch appliedTD(s) on specific platform

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
    * def pageSize = 10

    Given path '/api/v1/technical-definitions/', platform.id ,'/appliedTds'
    When method get
    Then status 200
    And match response  ==  '#present'

