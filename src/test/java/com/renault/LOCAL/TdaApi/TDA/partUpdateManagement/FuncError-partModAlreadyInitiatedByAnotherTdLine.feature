Feature: As a tda client, I want to validate the functional error "PART_MODIFICATION_ALREADY_INITIATED_BY_ANOTHER_TD_LINE"

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 409 : Validate the functional Error "PART_MODIFICATION_ALREADY_INITIATED_BY_ANOTHER_TD_LINE"


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
    * def Material =  "Material" + ' ' + random_string(5)
    * def Protection =  "Protection" + ' ' + random_string(5)
    * def PartRevisionNote =  "Part Revision Note" + ' ' + random_string(5)

    #   POST - Create First TD line

    * def newLine = {"gfeCode": "GFE_11", "tdSource": "ONE TD"}

    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    * def firstTdItemId = $.tdItem.id
    * print 'First TD ItemId:', firstTdItemId
    * def firstLineId = $.esv.lineId
    * print 'First Line Id: ', firstLineId

    # PATCH - update part number for the created line
    * def reqData = {"partNumber": {"value": <partId>}}
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = firstTdItemId
    And request reqData
    When method patch
    Then status 200
    And match response == '#present'

    # POST - Update the part details
    * def partModReq =
    """
    {
      "lineNumber": #(firstLineId),
      "part": {
        "associatedDocuments": [
        ],
        "basicPartCode": "",
        "companyMembership": <companyMembership>,
        "complementNameNumber": 0,
        "designTypology": <designTypology> ,
        "hasCoLeader": true,
        "importantPartSymbol": <importantPartSymbol>,
        "material": <material>,
        "newRevisionLevel": true,
        "partId": <partId>,
        "partKind": <partKind>,
        "partRevisionNote": <partRevisionNote>,
        "protection": <protection>,
        "rseCode": <rseCode>,
        "standardNameNumber": 0,
        "thickness": <thickness>,
        "unitOfUse": <unitOfUse>,
        "weight": <weight>,
        "weightType": <weightType>
      }
    }
    """
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/part-solutions/part-modification'
    And request partModReq
    When method post
    Then status 200
    * print 'Part details updated successfully'

    # Create the second TD Line
    * def secondLine = {"gfeCode": "GFE_11", "tdSource": "ONE TD"}
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines'
    And request secondLine
    When method post
    Then status 201
    And match response == '#present'
    * def secondTdItemId = $.tdItem.id
    * print 'Second TD ItemId:', secondTdItemId
    * def secondLineId = $.esv.lineId
    * print 'Second Line Id: ', secondLineId

    # Update same part number for the second line(The part no which is already updated in the first line)
    * def reqData = {"partNumber": {"value": <partId>}}
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = secondTdItemId
    And request reqData
    When method patch
    Then status 200
    And match response == '#present'

    # POST - Update the part details in the second line
    * def partModReq1 =
    """
    {
      "lineNumber": #(secondLineId),
      "part": {
        "associatedDocuments": [
        ],
        "basicPartCode": "",
        "companyMembership": <companyMembership>,
        "complementNameNumber": 0,
        "designTypology": <designTypology> ,
        "hasCoLeader": true,
        "importantPartSymbol": <importantPartSymbol>,
        "material": <material>,
        "newRevisionLevel": true,
        "partId": <partId>,
        "partKind": <partKind>,
        "partRevisionNote": <partRevisionNote>,
        "protection": <protection>,
        "rseCode": <rseCode>,
        "standardNameNumber": 10,
        "thickness": <thickness>,
        "unitOfUse": <unitOfUse>,
        "weight": <weight>,
        "weightType": <weightType>
      }
    }
    """
    * def expected =
    """
    {"errorDescription":"PART_MODIFICATION_ALREADY_INITIATED_BY_ANOTHER_TD_LINE","errors":[{"errorType":"functional","errorMessage":"#string","errorCode":"PART_MODIFICATION_ALREADY_INITIATED_BY_ANOTHER_TD_LINE","errorLevel":"error"}]}
    """
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/part-solutions/part-modification'
    And request partModReq1
    When method post
    Then status 409
    And match response == expected

    # Cancel the working version for Part
    * def partCancelWorkRequest = {"lineNumber": #(firstLineId)}
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/part-solutions/part-modification-cancellation'
    And request partCancelWorkRequest
    When method post
    Then status 200
    * print 'The Working Part is cancelled successfully'

    # Delete the first line
    Given path '/api/v1/technical-definition-lines/', firstTdItemId
    When method delete
    Then status 204
    And match response == '#present'
    * print 'The created line', firstLineId ,'is deactivated successfully'

    # Delete the second line
    Given path '/api/v1/technical-definition-lines/', secondTdItemId
    When method delete
    Then status 204
    And match response == '#present'
    * print 'The created line', secondLineId ,'is deactivated successfully'

    Examples:
      |tdCode|companyMembership|designTypology|importantPartSymbol|material|partId|partKind|partRevisionNote|protection|rseCode|thickness|unitOfUse|weight|weightType|
      |3     |"RENAULT"|"ANNOTATED_3D"|"A"|#(Material)|"058000001R"|"ALLIANCE_MASTER_PART"|#(PartRevisionNote)|#(Protection)|"PQE" |1|"CENTIMETER"|5|"AUTOMATICALY_CALCULATED"|
