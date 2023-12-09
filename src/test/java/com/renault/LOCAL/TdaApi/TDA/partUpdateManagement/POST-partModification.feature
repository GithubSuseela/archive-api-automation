Feature: As a tda client, I want to modify a part

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - Part Modification and Cancellation

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

    #   POST - Create a new TD line

    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    * def esvId = $.esv.id
    * print 'ESV Id: ', esvId
    * def tdItemId = $.tdItem.id
    * print 'TD ItemId:', tdItemId
    * def lineId = $.esv.lineId
    * print 'Line Id: ', lineId
    * def esvVersionId = $.esv.esvVersionId
    * print 'ESV VersionId: ', esvVersionId
    * def updatedAt = $.esv.createdAt
#   PATCH - update part number for the created line
    * def reqData =
    """
    {
        "partNumber": {
        "value": <partId>
      },
        "updatedByIpn": {
        "value": "z014082"
      },
        "updatedAt": {
        "value": #(updatedAt)
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = tdItemId
    And request reqData
    When method patch
    Then status 200
    And match response == '#present'

    # POST - Update the part details
    * def partModReq =
    """
    {
      "lineNumber": #(lineId),
      "part": {
        "associatedDocuments": [
        ],
        "companyMembership": <companyMembership>,
        "designTypology": <designTypology> ,
        "hasCoLeader": true,
        "material": #(Material),
        "importantPartSymbol": <importantPartSymbol>,
        "newRevisionLevel": true,
        "partId": <partId>,
        "partKind": <partKind>,
        "partRevisionNote": #(PartRevisionNote),
        "protection": <protection>,
        "rseCode": <rseCode>,
        "thickness": <thickness>,
        "unitOfUse": <unitOfUse>,
        "weight": <weight>,
        "weightType": <weightType>,
        "updatedByIpn": "z014082",
        "updatedAt": #(updatedAt)
      }
    }
    """
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/part-solutions/part-modification'
    And request partModReq
    When method post
    Then status 200
    And match response == '#present'
    # Verify whether the part details are updated successfully
    * def partUpdatedDetails =
    """
      {
        "companyMembership": <companyMembership>,
        "designTypology": <designTypology> ,
        "coleaderFlag": "#boolean",
        "materialName": #(Material),
        "importantPart": <importantPartSymbol>,
        "newRevisionLevel": true,
        "partNumber": <partId>,
        "partKind": <partKind>,
        "revisionLevelCommentEn": #(PartRevisionNote),
        "uvTreatment": <protection>,
        "rse": <rseCode>,
        "thickness": <thickness>,
        "unitOfUse": <unitOfUse>,
        "legacyWeight": <weight>,
        "legacyWeightType": <weightType>,
        "createdByIpn": "#string",
        "createdAt": "#string",
        "updatedByIpn": "#string",
        "updatedAt": "#string",
        "id": "#string",
        "workingStatus":"WORKING_REVISION"
      }
    """
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines'
    And param esvLineIds = lineId
    When method GET
    Then status 200
    And match response == '#present'
#    * print response
    And match $.tdLines[0].ts.workingPart contains partUpdatedDetails
    # Cancel the working version for Part
    * def partCancelWorkRequest = {"lineNumber": #(lineId)}
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/part-solutions/part-modification-cancellation'
    And request partCancelWorkRequest
    When method post
    Then status 200
    * print 'The Working Part is cancelled successfully'
    # Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'
    * print 'The created line', lineId ,'is deactivated successfully'
#  058000001R - renault Part
#  XR5606XK0A - Nissan Part
#  "importantPart": <importantPartSymbol> [for Nissan part we need to Validate]
    Examples:
      |tdCode|companyMembership|designTypology|importantPartSymbol|partId|partKind|protection|rseCode|thickness|unitOfUse|weight|weightType|
      |3     |"RENAULT"|"ANNOTATED_3D"|"A"|"751757868R"|"ALLIANCE_MASTER_PART"|#(Protection)|"PQE" |"1"|"CENTIMETER"|0|"AUTOMATICALY_CALCULATED"|

