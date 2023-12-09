@ignore
#Tested by TDPTF-1031
Feature: As a tda api client, i want to get the the Basic Part standard names from a part number

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the the Basic Part standard names from a part number

    Given path '/api/v1/parts'
    And param familyCode = 'PFE'
    When method get
    Then status 200
    And def part = karate.jsonPath(response, "$.parts")[0]

    Given path '/api/v1/parts/', part.partId ,'/standard-names'
    When method get
    Then status 200
    And match response  ==  '#present'

