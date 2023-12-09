Feature: As a tda api client, I want to get the history of specific data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Fetch history of specific data

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
#    * def vehicle = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE' && @.company=='RENAULT')]")[0]
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]
    * match platform  ==  '#present'
    * def tdCode = platform.code
    * print tdCode

    Given path '/api/v1/technical-definitions/code/', tdCode
    When method get
    Then status 200
    And match response  ==  '#present'
    * def tdId = response.id
    * print tdId

    Given path '/api/v1/technical-definitions/', tdId ,'/specific-data/history'
    And param since = <since>
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response
    And match  $.specificData[*].projectSpecificData contains {"smaId" : '#string', "sourcingBatch" : '#string', "sourcingCompetition" : '#string'}

    Examples:
      |since|
      |"2021-12-11T14:01:17.985Z" |