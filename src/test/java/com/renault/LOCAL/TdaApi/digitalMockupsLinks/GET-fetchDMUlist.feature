Feature: As a tda api client, i want to fetch the list of Digital Mockups linked to the Technical Definition

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Fetch the list of Digital Mockups linked to the Technical Definition

    * def code = '<Code>'
    * def resp1 = {"dmuLinks": [{"dmuName": "#string", "dmuType": "#string", "isActive": "#boolean"}]}
    * def resp2 = {"code": 404, "message": "Not Found", "description": "No technical definition found with code = 0"}
    Given path '/api/v1/technical-definitions/', code ,'/dmu-links'
    When method GET
    Then status <Status>
    * match response contains <expected>

    Examples:
    |Code|Status|expected|
    |46  |200   |resp1   |
    |0   |404   |resp2   |
