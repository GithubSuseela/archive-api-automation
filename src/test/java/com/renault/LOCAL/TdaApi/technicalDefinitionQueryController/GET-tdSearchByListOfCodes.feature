@ignore
#Tested by TDPTF-1161
Feature: As a tda api client, I want to find a List of TD included in the list of codes

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the TD list included in the list of codes

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform0 = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
    And def platform1 = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[1]
    And def platform2 = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[2]
    And def code0 = platform0.code
    And def code1 = platform1.code
    And def code2 = platform2.code

    Given path '/api/v1/technical-definitions/search'
    And params ({ codes: code0, codes: code1 })
    #And params codes = code0 , code1 , code2
    #And param codes = [platform0.code , platform1.code]
    When method get
    Then status 200
    And match response  ==  '#present'
