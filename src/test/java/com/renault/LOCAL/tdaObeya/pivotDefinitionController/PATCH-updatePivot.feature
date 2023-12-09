Feature: As a tda client, I want to Update the properties of a pivot perimeter

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 204 - Update the properties (TD Code) of a pivot perimeter

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
    * print descEn
    * def descFr =  "FR description pivot" + ' ' + random_string(10)
    # Pivot short name length is 20
    * print descFr
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
          "pivotVisibility": "<pivotVisibility>",
          "pivotStatus": {
          "costingState": "<costingState>"
          }
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
#   Update the properties of the Pivot Perimeter (Ex: TD Code)
    * def patchReq = {"technicalDefinitionCode": 45}
    * def patchResp1 = {"errorDescription":"TD_CODE_ALREADY_SPECIFIED","errors":[{"errorType":"functional","errorMessage":"The TD code of the vehicle has already been specified; it is not possible to change it","errorCode":"TD_CODE_ALREADY_SPECIFIED","errorLevel":"error"}]}
    Given path '/api/v1/pivots/', pivotNumber ,'/pivot-perimeter'
    And request patchReq
    When method patch
    Then status <status>
    And match response == '#present'
#    * print response
    And match response == <expected>

    Examples:
    |perimeterScope|tdCode|shortName|descriptionEn|descriptionFr|expression|pivotVisibility|status|expected|costingState|
    |VEHICLE_TD    |45        |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PUBLIC         |409|patchResp1|NOT_READY_FOR_FULL_COST|
    |VEHICLE_TD    |null      |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PRIVATE        |204|''        |NOT_READY_FOR_FULL_COST|
