@ignore
#Tested by TDPTF-965
Feature: As a tda user, I want to get the line by tdId and esvId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch the TD line by tdId and esvId

    #GET the esvID of the line
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]
    And match platform == '#present'

    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    And def tdId = response.tdId

    Given path '/api/v1.1/technical-definitions/', tdId ,'/technical-definition-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.content")[0]
    And def ESVId = karate.jsonPath(tdLines, "esv.id")
    And match tdLines == '#present'
    And match ESVId == '#present'

    #GET the project tdID of the line
    Given path '/api/v1/technical-definitions/', tdId ,'/project-applicabilities'
    And param code = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    And def resp = karate.jsonPath(response, "$.applied")[0]
    And def appTdId = resp.id

    #Fetch the TD line by tdId and esvId
    Given path '/api/v1/technical-definitions/', appTdId ,'/applied-technical-definition-line'
    And param esvId = ESVId
    When method get
    Then status 200
    And match response  ==  '#present'

