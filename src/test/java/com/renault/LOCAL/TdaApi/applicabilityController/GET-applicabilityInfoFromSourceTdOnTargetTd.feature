Feature: As a tda client, I want to get a list of applications from source td on target td

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Returns a list of applications from source td on target td
# srcTd = 3 and targetTd = 45
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
    Given path '/api/v1/technical-definitions/',<srcTdId> ,'/applied-on/', <targetTdId> ,'/applicabilities'
    When method get
    And call sleep 10
    Then status 200
    And match response == '#present'

    Examples:
      |srcTdId|targetTdId|
      |'fe632f65-b0f6-4f5d-b5ab-5a431b0e6119'|'8e7a63b1-a9a0-49cf-9faa-c673e136a055'|