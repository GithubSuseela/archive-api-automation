Feature: As a tda api client, i want to get design note approvals by DN Id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch design note approvals by Design Note Id

    # Get design note Id of the status 'PUBLISHED'
    Given path '/api/v1/design-notes'
    When method get
    Then status 200
    And def designNote = karate.jsonPath(response, "$.designNotes")[0]
    And match designNote  ==  '#present'
    * def designNote = karate.jsonPath(response, "$.designNotes[?(@.status.code=='PUBLISHED')]")[0]
    * def designNoteId = designNote.id

    * def sleep =
      """
      function(seconds){
        for(i = 0; i <= seconds; i++)
        {
          java.lang.Thread.sleep(1*1000);
          karate.log(i);
        }
      }
      """
    # Get Design Note approvals by design note id
    Given path '/api/v1/design-notes/', designNoteId ,'/approvals'
    When method get
#    And call sleep 5
    Then status 200
    And match response  ==  '#present'