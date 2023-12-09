Feature: As a tda client, I want to get group by UUID

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch group by UUID

    # Get all groups
    Given path '/api/v1/groups'
    And param technicalDefinitionCode = 3
    When method get
    Then status 200
    And match response == '#present'
    And def groups = karate.jsonPath(response, "$.groups")[0]
    And def grpId = groups.groupId
    * print 'Group UUID: ', grpId

    # Get group by groupId
    Given path '/api/v1/groups/', grpId
    When method get
    Then status 200
    And match response == '#present'
    And match response contains { "groupId": '#(grpId)' }
