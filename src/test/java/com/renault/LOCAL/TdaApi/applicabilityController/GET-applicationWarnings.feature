@ignore
#Tested by TDPTF-966
Feature: As a tda user, i want to get the list of application warnings for the input platform

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Query for lines to get the list of application warnings

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
#    And match platform == '#present'
#    * print platform

    Given path '/api/v1/technical-definitions/code/', platform.tdCode
    When method get
    Then status 200
    And def tdId = response.id
#    And match tdId == '#present'

    Given path '/api/v1/technical-definitions/', tdId , '/application-warnings'
    When method get
    And configure readTimeout = 100000
    Then status 200
    And match response  ==  '#present'
