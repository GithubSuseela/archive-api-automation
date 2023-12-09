Feature: As a tda client, I want to create a pivot definition for a technical definition

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - create a pivot definition for a technical definition

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
    * def random_No =
       """
       function(s) {
         var text = "";
         var possible = "123456789";
         for (var i = 0; i < s; i++)
           text += possible.charAt(Math.floor(Math.random() * possible.length));
         return text;
       }
       """
    * def descEn =  "EN description pivot" + ' ' + random_string(10)
    * def descFr =  "FR description pivot" + ' ' + random_string(10)
    * def SName =  "Pivot name" + ' ' + random_string(5)
    * def expr =  "Pivot Expression" + ' ' + random_string(10)
    * def randomPerimeterId = random_No(3)
    # Success scenario with valid values  && "pivotVisibility": "PUBLIC"
    * def createPivot1 = {"pivotPerimeter": {"perimeterScope": "VEHICLE_TD","perimeterId": #(randomPerimeterId)} , "pivotDescription": {"shortName":  #(SName),"descriptionEn": #(descEn), "descriptionFr": #(descFr)}, "pivotDiversity": {"expression": #(expr)},"pivotVisibility": "PUBLIC"}
    * def expected1 = {"pivotNumber": "#number","pivotDiversity": {"expression": #(expr)},"createdAt": "#string","pivotDescription": {"descriptionEn": #(descEn),"shortName": #(SName),"descriptionFr": #(descFr)},"updatedBy": "#string","createdBy": "#string","pivotPerimeter": {"perimeterId": #(randomPerimeterId),"perimeterScope": "VEHICLE_TD"},"pivotVisibility": "PUBLIC", "updatedAt": "#string"}
    # Success scenario with valid values  && "pivotVisibility": "PRIVATE"
    * def createPivot2 = {"pivotPerimeter": {"perimeterScope": "VEHICLE_TD","perimeterId": #(randomPerimeterId)} , "pivotDescription": {"shortName":  #(SName),"descriptionEn": #(descEn), "descriptionFr": #(descFr)}, "pivotDiversity": {"expression": #(expr)},"pivotVisibility": "PRIVATE"}
    * def expected2 = {"pivotNumber": "#number","pivotDiversity": {"expression": #(expr)},"createdAt": "#string","pivotDescription": {"descriptionEn": #(descEn),"shortName": #(SName),"descriptionFr": #(descFr)},"updatedBy": "#string","createdBy": "#string","pivotPerimeter": {"perimeterId": #(randomPerimeterId),"perimeterScope": "VEHICLE_TD"},"pivotVisibility": "PRIVATE", "updatedAt": "#string"}
    # perimeterScope is null
    * def createPivot3 = {"pivotPerimeter": {"perimeterScope": "","perimeterId": 113} , "pivotDescription": {"shortName":  #(SName),"descriptionEn": #(descEn), "descriptionFr": #(descFr)}, "pivotDiversity": {"expression": #(expr)},"pivotVisibility": "PUBLIC"}
    * def expected3 = {"errorCode": "BAD_REQUEST", "errorMessage": "#string",   "errorLevel": "error",  "errorType": "technical"}
    # pivotVisibility is null
    * def createPivot4 = {"pivotPerimeter": {"perimeterScope": "","perimeterId": 113} , "pivotDescription": {"shortName":  #(SName),"descriptionEn": #(descEn), "descriptionFr": #(descFr)}, "pivotDiversity": {"expression": #(expr)},"pivotVisibility": ""}
    * def expected4 = {"errorCode": "BAD_REQUEST", "errorMessage": "#string",   "errorLevel": "error",  "errorType": "technical"}
    # Invalid TD Code --- need to discuss on this -- since it is not validating the td code
    Given path '/api/v1/pivots'
    And request <createPivot>
    When method post
    Then status <Status>
    And match response == '#present'
    And match response == <expected>

    Examples:
      |createPivot|Status|expected|
      |createPivot1|201  |expected1|
      |createPivot2|201  |expected2|
      |createPivot3|400  |expected3|
      |createPivot4|400  |expected4|