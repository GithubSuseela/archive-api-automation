Feature: As a tda api client, I want to Activate/Deactivate Digital Mockups linked to the Technical Definition

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 200 - Activate/Deactivate Digital Mockups linked to the Technical Definition

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
    * def postReq = {"dmuName": '#(dmuName)', "dmuType": "PLATFORM", "isActive": true}
    * def postResp = {"dmuName": '#(dmuName)', "dmuType": "PLATFORM", "isActive": true}
    Given path '/api/v1/technical-definitions/', code ,'/dmu-links'
    And request postReq
    When method post
    Then status 201
    * match response == postResp
    # Update Linked Digital Mockups
    * def patchReq = {"isActive": true}
    * def patchResp = {"dmuLinks": [{"dmuName": "#string","dmuType": "PLATFORM","isActive": true}]}
    Given path '/api/v1/technical-definitions/', code ,'/dmu-links/', dmuName
    And request patchReq
    When method patch
    Then status 200
    * match response contains patchResp
    Examples:
      |Code|
      |46  |
