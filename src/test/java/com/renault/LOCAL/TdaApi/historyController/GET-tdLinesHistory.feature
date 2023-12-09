Feature: As a tda api client, I want to get the TD Lines History

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Find TD Lines History

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def vehicle = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE' && @.company=='RENAULT')]")[10]
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[10]
    * match platform  ==  '#present'
    * match vehicle  ==  '#present'
    * def vehicleCode = vehicle.code
    * def platformCode = platform.code

    Given path '/api/v1/technical-definitions/code/', <code>
    When method get
    Then status 200
    And match response  ==  '#present'
    * def tdId = response.id
    * print tdId

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
    Given path '/api/v1/technical-definitions/', tdId ,'/lines/history'
    And param since = <since>
    And param tdType = <TdType>
    When method get
    And call sleep 10
    Then status 200
    And match response  ==  '#present'
#    * print response
    * def tdLine = karate.jsonPath(response, "$.tdLines")[0]
#    * print tdLine
    And match tdLine contains {version: '#string'}


    Examples:
      |code|since|TdType|
      |vehicleCode|"2020-02-11T14:01:17.985Z" |"PLATFORM"|
      |platformCode|"2020-02-11T14:01:17.985Z"|"PLATFORM"|
