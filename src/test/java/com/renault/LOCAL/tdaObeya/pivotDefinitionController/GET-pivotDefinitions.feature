Feature: As a tda client, I want to get the list of pivots that match a list of specified search criteria

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Pivot List

    # Create a pivot
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
    * def descEn =  "EN description pivot" + ' ' + random_string(10)
    * def descFr =  "FR description pivot" + ' ' + random_string(10)
    # Pivot short name length is 20
    * def SName =  "Pivot name" + ' ' + random_string(5)
    * def expr =  "Pivot Expression" + ' ' + random_string(10)
    * def createPivot =
        """
        {
          "pivotPerimeter": {
            "perimeterScope": "<perimeterScope>",
            "technicalDefinitionCode": <tdCode>
          },
          "pivotDescription": {
            "shortName":  "<shortName>",
            "descriptionEn": "<descriptionEn>",
            "descriptionFr": "<descriptionFr>"
          },
          "pivotDiversityCoverage": {
            "expression": "<expression>"
          },
          "pivotVisibility": "<pivotVisibility>",
          "pivotStatus": {
          "costingState": "<costingState>"
          }
        }
        """
    Given path '/api/v1/pivots'
    And request createPivot
    When method post
    Then status 201
    And match response == '#present'
    * def pivotNo = response.createdPivotNumber
#    * print response
    * print pivotNo

    * def pivotResp =
      """
        {
          "pivotNumber": #(pivotNo),
          "pivotPerimeter": {
            "perimeterScope": <perimeterScope>,
            "technicalDefinitionCode": <tdCode>
          },
          "pivotDescription": {
            "descriptionEn": <descriptionEn>,
            "shortName": <shortName>,
            "descriptionFr": <descriptionFr>
          },
          "pivotDiversityCoverage": {
            "expression": <expression>
          },
          "pivotUsage": {},
          "pivotStatus": {
            "isCandidateForFullCost": false,
            "costingState": <costingState>
          },
          "createdAt": "#string",
          "updatedBy": "#string",
          "createdBy": "#string",
          "updatedAt": "#string"
        }
      """
    #Verify the created pivot by GET request
    Given path '/api/v1/pivots'
    And param pivotNumber = pivotNo
    When method get
    Then status 200
    And match response == '#present'
#    * print response
    And match $..pivots[*] contains pivotResp

    Examples:
      |perimeterScope|tdCode|shortName|descriptionEn|descriptionFr|expression|pivotVisibility|costingState|
      |VEHICLE_TD    |45        |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PUBLIC         |NOT_READY_FOR_FULL_COST|
