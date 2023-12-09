Feature: As a tda user, I want to get the list of applications from source td on target td.

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch the list of applications from source td on target td

    #GET the source TDId of the line
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
    And def srcTdId = response.tdId

    #GET the project tdID (target) of the line
    Given path '/api/v1/technical-definitions/', srcTdId ,'/project-applicabilities'
    And param code = platform.code
    When method get
    Then status 200
    And match response  ==  '#present'
    And def resp = karate.jsonPath(response, "$.applied")[0]
    And def targetTdId = resp.id

    #Fetch the TD line by tdId and esvId
    Given path '/api/v1/technical-definitions/', srcTdId ,'/applied-on/', targetTdId ,'/applicabilities'
    When method get
    Then status 200
    And match response  ==  '#present'




