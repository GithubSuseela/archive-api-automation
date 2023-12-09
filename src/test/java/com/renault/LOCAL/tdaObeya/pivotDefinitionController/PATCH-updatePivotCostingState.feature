Feature: As a tda client, I want to Update a pivot to change costing state

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 204 - Update a pivot to change costing state

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
#   Create a Pivot
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
          "pivotVisibility": "<pivotVisibility>"
        }
        """
    * def resp = {"createdPivotNumber": '#number'}
    Given path '/api/v1/pivots'
    And request createPivot
    When method post
    Then status 201
    And match response == '#present'
    And match response == resp
    * def pivotNumber = $.createdPivotNumber
#   Update the costing state
    * def patchReq = {"costingState": <costingState>}
    Given path '/api/v1/pivots/', pivotNumber ,'/pivot-status'
    And request patchReq
    When method patch
    Then status <status>
    And match response == '#present'

    Examples:
    |perimeterScope|tdCode|shortName|descriptionEn|descriptionFr|expression|pivotVisibility|costingState|status|
    |VEHICLE_TD    |45        |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PUBLIC         |"READY_FOR_FULL_COST"|204|
    |VEHICLE_TD    |null      |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PRIVATE        |"NOT_READY_FOR_FULL_COST"|204|
    |VEHICLE_TD    |null      |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PRIVATE        |"FULL_COST"|400|
