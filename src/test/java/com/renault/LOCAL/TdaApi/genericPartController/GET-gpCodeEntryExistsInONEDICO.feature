@ignore
#Tested by TDPTF-1012
Feature: As a tda api client, i want to check whether the gpCode entry exists in One Dico

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  GET - 200 - check whether the gpCode entry exists in One Dico

    Given path '/api/v1/work-orders'
    And param status = 'OPEN'
    When method get
    Then status 200
    And def resp =  karate.jsonPath(response, "$.workOrderResources")[0]

    Given path '/api/v1/generic-parts'
    And param gpCode = resp.genericPartCode
    When method get
    Then status 200
    And match response  ==  '#present'
