@ignore
#Tested by TDPTF-1160
Feature: As a tda api client, I want to get the TD(s) by its projectTdCode(s)

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the TD(s) by its projectTdCode(s)

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
    * def pageSize = 10

    Given path '/api/v1/technical-definitions/code', platform.code
    When method get
    Then status 200
    And assert response.code == platform.code
    And def prjTdCode = response.projectTdCode

    Given path '/api/v1/technical-definitions/projectTdCode/', prjTdCode
    When method get
    Then status 200
    And match response  ==  '#present'
