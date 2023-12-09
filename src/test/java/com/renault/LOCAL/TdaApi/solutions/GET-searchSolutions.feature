Feature: As a tda api client, i want to Search solutions matching a set of search criteria

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  GET - 200 - Search solutions matching a set of search criteria

    Given path '/api/v1/engineering-solutions'
    And param familyCode = <familyCode>
    And param partId = <PartId>
    When method get
    Then status <Status>
    And match response  ==  '#present'

    Examples:
    |familyCode|PartId|Status|
    |'PFJ'     |''    |206   |
    |'PFE'     |'259906321R'|200|
