@ignore
#Tested by TDPTF-971
Feature: As a tda api client, I want to get the Assembly details by esvId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch the Assembly details by esvId

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]
#    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id
#    And match platformId == '#present'

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content[?(@.assemblyPosition=='PART_OF')]")[0]
#    And match tdLines == '#present'
    And def esvId = karate.jsonPath(tdLines, "esv.id")
#    And match esvId == '#present'

    Given path '/api/v1/assemblies', esvId ,'/children'
    When method get
    Then status 200
    And match response  ==  '#present'
