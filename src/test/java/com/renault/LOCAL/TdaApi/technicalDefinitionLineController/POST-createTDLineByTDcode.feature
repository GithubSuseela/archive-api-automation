Feature: As a tda client, I want to Create a TD Line by tdCode

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 201 - Create a TD Line by TD code

    Given path '/api/v0/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
    * def tdCode = platform.code
    * def requestData =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def tdItemId = $.tdItem.id
    * def lineId = $..lineId
    # * print response
    #    Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'

