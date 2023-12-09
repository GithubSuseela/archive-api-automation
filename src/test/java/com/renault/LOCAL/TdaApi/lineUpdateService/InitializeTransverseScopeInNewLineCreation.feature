Feature: As a tda client, I want to verify the transverseScope initialized when a line is created

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - verify the transverseScope initialized when a line is created

#   Get TD Code
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.<Type>")[0]
#    And match platform == '#present'

#   POST - Create a new TD line
    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', platform.tdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    * def tdItemId = $.tdItem.id
    And match $.esv.transverseScope == <expected>

    #    Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'

    Examples:
      |Type|expected|
      |platformTechnicalDefinitions|'PLATFORM'|
#      |'VEHICLE' |'UPPER_BODY'|
#      |'UPPER_BODY'|'UPPER_BODY'|

