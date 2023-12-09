@ignore
#Tested by TDPTF-1029
Feature: As a tda api client, i want to get the Partnerships Details by PartNumber from BOM Legacy

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the Partnerships Details by PartNumber from BOM Legacy

    Given path '/api/v1/parts'
    And param familyCode = 'PFE'
    When method get
    Then status 200
    And def part = karate.jsonPath(response, "$.parts")[0]

    Given path '/api/v1/parts/', part.partId ,'/partnerships'
    When method get
    Then status 200
    And match response  ==  '#present'

