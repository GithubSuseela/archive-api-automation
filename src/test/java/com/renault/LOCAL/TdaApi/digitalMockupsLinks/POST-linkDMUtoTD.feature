Feature: As a tda api client, i want to link the input Digital Mockup to the Technical Definition

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Links the input Digital Mockup to the Technical Definition

    * def random_string =
       """
       function(s) {
         var text = "";
         var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
         for (var i = 0; i < s; i++)
           text += possible.charAt(Math.floor(Math.random() * possible.length));
         return text;
       }
       """
    * def dmuName =  random_string(6)
    * def code = '<Code>'
    #Create DMU links
    * def req1 = {"dmuName": '#(dmuName)', "dmuType": "PLATFORM", "isActive": true}
    * def resp1 = {"dmuName": '#(dmuName)', "dmuType": "PLATFORM", "isActive": true}
    #Verify error message for invalid TD code
    * def resp2 = {"code": 404, "message": "Not Found", "description": "No technical definition found with code = 0"}
    #Verify the length of dmuName field doesn't exceeds '6'
    * def req3 = {"dmuName": "DMUtd15", "dmuType": "PLATFORM", "isActive": true}
    * def resp3 = {"code": 400, "message": "Bad Request", "description": "length must be between 0 and 6"}

    Given path '/api/v1/technical-definitions/', code ,'/dmu-links'
    And request <req>
    When method post
    Then status <Status>
    * match response == <expected>

    Examples:
      |Code|req|Status|expected|
      |46  |req1|201   |resp1   |
      |0  |req1|404   |resp2   |
      |46 |req3|400   |resp3   |