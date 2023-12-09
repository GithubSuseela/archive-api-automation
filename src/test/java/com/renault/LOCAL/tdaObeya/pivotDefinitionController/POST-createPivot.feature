Feature: As a tda client, I want to create a pivot definition for a technical definition

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - create a pivot definition for a technical definition

#    # GET TD code  --- This endpoint is in TDA / not in obeya - need to find a solution for running two different urls
#    Given path '/api/v0/technical-definitions'
#    When method get
#    Then status 200
##    And def platform = karate.jsonPath(response, "$.projects[?(@.type=='PLATFORM')]")[0]
#    And def vehicle = karate.jsonPath(response, "$.projects[?(@.type=='VEHICLE')]")[0]
#    * def code = vehicle.code

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
    * def resp = {"createdPivotNumber": '#number'}
    Given path '/api/v1/pivots'
    And request createPivot
    When method post
    Then status 201
    And match response == '#present'
    And match response == resp
    * print response
    * def pivotNumber = $.createdPivotNumber
    * print 'Created Pivot Number: ', pivotNumber
    # Delete the created pivot
    Given path '/api/v1/pivots/', pivotNumber
    When method delete
    Then status 204
    And match response == '#present'
    * print 'The Pivot Number is Deleted successfully'

    Examples:
    |perimeterScope|tdCode|shortName|descriptionEn|descriptionFr|expression|pivotVisibility|costingState|
    |VEHICLE_TD    |45        |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PUBLIC         |NOT_READY_FOR_FULL_COST|
    |VEHICLE_TD    |null      |#(SName) |#(descEn)    |#(descFr)    |#(expr)   |PRIVATE        |NOT_READY_FOR_FULL_COST|
