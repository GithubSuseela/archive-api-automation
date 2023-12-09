@ignore
#Tested by TDPTF-1028
Feature: As a tda api client, i want to get the Part Details from BOM Legacy

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the Part Details from BOM Legacy

    Given path '/api/v1/parts'
    And param familyCode = 'PFE'
    When method get
    Then status 200
    And def part = karate.jsonPath(response, "$.parts")[0]

    Given path '/api/v1/parts/' , part.partId
    When method get
    Then status 200
    And match response  ==  '#present'
    And assert response.partId == part.partId

