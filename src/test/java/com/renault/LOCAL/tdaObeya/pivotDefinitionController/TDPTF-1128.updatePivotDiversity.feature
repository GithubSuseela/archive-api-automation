Feature: As a tda client, I want to update the diversity of a pivot

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PUT - 201 - Update the pivotDiversityCoverage and pivotDescription  of a pivot

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
    #Update the diversity of the created pivot
    * def putReq = {"expression": "(BCB/RV,RVDIST)"}
    Given path '/api/v1/pivots/', pivotNumber ,'/diversity-coverage'
    And request putReq
    When method put
    Then status 204
    #Update the description of the created pivot
    * def updateDescEn =  "Updated EN description pivot" + ' ' + random_string(10)
    * def updateDescFr =  "Updated FR description pivot" + ' ' + random_string(10)
    * def updateSName =  "PN updated" + ' ' + random_string(5)
    * def putReq1 = {"shortName": "#(updateSName)", "descriptionEn": "#(updateDescEn)", "descriptionFr": "#(updateDescFr)"}
    Given path '/api/v1/pivots/', pivotNumber ,'/description'
    And request putReq1
    When method put
    Then status 204
    #Verify the diversity of pivot is updated by GET method
    * def pivotResp =
      """
        {
          "pivotNumber": #(pivotNumber),
          "pivotDiversityCoverage": {
            "expression": "(BCB/RV,RVDIST)"
          },
          "createdAt": "#string",
          "pivotDescription": {
            "descriptionEn": "#(updateDescEn)",
            "shortName": "#(updateSName)",
            "descriptionFr": "#(updateDescFr)"
          },
          "updatedBy": "#string",
          "pivotStatus": {
            "costingState": <costingState>
          },
          "createdBy": "#string",
          "pivotPerimeter": {
            "perimeterScope": <perimeterScope>,
            "technicalDefinitionCode": <tdCode>
          },
          "pivotVisibility": <pivotVisibility>,
          "updatedAt": "#string"
        }
      """
    Given path '/api/v1/pivots'
    And param technicalDefinitionCode = <tdCode>
    When method get
    Then status 200
    And match response == '#present'
#    And match $..pivots[*] contains pivotResp
#    And def updatedPivot = karate.jsonPath(response, "$.pivots[?(@.pivotNumber== #(pivotNumber))]")
#    * print updatedPivot
    Examples:
      |perimeterScope|tdCode|shortName|descriptionEn|descriptionFr|expression|pivotVisibility|costingState|
      |VEHICLE_TD    |45        |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PUBLIC         |NOT_READY_FOR_FULL_COST|