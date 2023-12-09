@ignore
#Tested by TDPTF-976
Feature: As a OneTD user, i want to get the design note tdLines

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Retrieve design note tdLines

    Given path '/api/v1/design-notes'
    When method get
    Then status 200
    And def designNote = karate.jsonPath(response, "$.designNotes[?(@.status.code=='PUBLISHED')]")[0]

    Given path '/api/v1/design-notes/', designNote.id, '/td-lines'
    When method get
    Then status 200
    And match response  ==  '#present'

