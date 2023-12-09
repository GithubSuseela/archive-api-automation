Feature: As a tda client, I want to Select a vehicle architecture zone

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 201 - Select a vehicle architecture zone

    #Request to get first PLATFORM code
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def vehicle = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE' && @.company=='RENAULT')]")[0]
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]
    * match platform  ==  '#present'
    * match vehicle  ==  '#present'
    * def vehicleCode = vehicle.code
    * def platformCode = platform.code
#    * print platform
#    * print vehicle

   	#Request to get platform id and line number
    Given path '/api/v1/technical-definitions/code/', platformCode
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response
    * def tdId = response.id
#    * print tdId

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
# Request to get tdLines
    Given path '/api/v1.1/technical-definitions/', tdId ,'/technical-definition-lines'
    When method get
    And call sleep 10
    Then status 200
    And match response  ==  '#present'