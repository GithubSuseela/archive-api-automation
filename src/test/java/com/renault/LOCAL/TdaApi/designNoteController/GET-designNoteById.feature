@ignore
#Tested by TDPTF-975
Feature: As a OneTD user, i want to get the list of design notes by id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Retrieve designNote by id

    Given path '/api/v1/design-notes'
    When method get
    Then status 200
    And def designNote = karate.jsonPath(response, "$.designNotes[?(@.status.code!='DRAFT')]")[0]

    Given path '/api/v1/design-notes/', designNote.id ,'/approvals'
    When method get
    And configure readTimeout = 100000
    Then status 200
    And match response  ==  '#present'


