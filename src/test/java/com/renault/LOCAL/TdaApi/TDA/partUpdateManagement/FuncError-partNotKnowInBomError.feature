Feature: As a tda client, I want to validate the functional error "PART_NOT_KNOWN_IN_THE_BOM_LEGACY"

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 409 : Validate the functional Error "PART_NOT_KNOWN_IN_THE_BOM_LEGACY"

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

    # POSt - 409 - Validate functional error "PART_NOT_KNOWN_IN_THE_BOM_LEGACY"
    * def partModReq =
    """
    {
      "lineNumber": #(lineId),
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
#        "nameEn": "string",
#        "nameFr": "string",
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
    * def expected =
    """
    {"errorDescription":"PART_NOT_KNOWN_IN_THE_BOM_LEGACY","errors":[{"errorType":"functional","errorMessage":"It is not possible to create a working version of the part, because it is not known by BOM","errorCode":"PART_NOT_KNOWN_IN_THE_BOM_LEGACY","errorLevel":"error"}]}
    """
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/part-solutions/part-modification'
    And request partModReq
    When method post
    Then status 409
    And match response == expected

    # Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'
    * print 'The created line', lineId ,'is deactivated successfully'

    Examples:
      |tdCode|companyMembership|designTypology|importantPartSymbol|material|partId|partKind|partRevisionNote|protection|rseCode|thickness|unitOfUse|weight|weightType|
      |3     |"RENAULT"|"ANNOTATED_3D"|"A"|#(Material)|"215035507R"|"ALLIANCE_MASTER_PART"|#(PartRevisionNote)|#(Protection)|"PQE" |1|"CENTIMETER"|5|"AUTOMATICALY_CALCULATED"|
