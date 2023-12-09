Feature: As a tda api client, I want to verify Specific Data details values which is available for the TD line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario: [Views] Verify the “Specific Data” values available for the TD line

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = 2
    When method get
    Then status 200
    And match response  ==  '#present'
    And def specificDataAttributes = karate.jsonPath(response, "$..lines[0].specificData")
#    * print specificDataAttributes
    * def diversity = {"forecastDiversity": "#string"}
    And match $..lines[*].specificData.diversity contains diversity
    And match $..lines[*].specificData.note contains "#string"
    And match $..lines[*].specificData.toolingSchedule contains "#string"
    And match $..lines[*].specificData.reuseCategory contains "#string"
    And match $..lines[*].specificData.makeOrBuy contains "#string"
