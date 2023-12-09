@ignore
#Tested by TDPTF-1032
Feature: As a tda api client, i want to Check in g2b the availability of a part id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Check the availability of a part id in g2b

    Given path '/api/v1/parts'
    And param familyCode = 'PFE'
    When method get
    Then status 200
    And def part = karate.jsonPath(response, "$.parts[?(@.beResponsible=='Nissan')]")[0]

    Given path '/api/v1/g2b/part-ids/', part.partId
    When method get
    Then status 200
    And match response  ==  '#present'

