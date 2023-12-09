@ignore
#Tested by TDPTF-977
Feature: As a OneTD user, i want to validate design note on creation

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 -  validate design note on creation

    Given path '/api/v1/design-notes'
    When method get
    Then status 200
    And def designNote = karate.jsonPath(response, "$.designNotes[?(@.status.code!='DRAFT')]")[0]

    Given path '/api/v1/design-notes/', designNote.id, '/td-lines'
    When method get
    Then status 200
    And def tdLines = karate.jsonPath(response, "$.tdLines")[0]
    And def tdLinesId = tdLines.id

    Given path '/api/v1/design-notes/validate-td-lines'
    And param tdLineIds = tdLinesId
    When method get
    Then status 200
    And match response  ==  '#present'
