Feature: As a tda client, I want to Update Technical Solution Variant Item based on ESV Vesion Id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: PUT - 200 - Update Technical Solution Variant Item based on ESV Vesion Id
    #   POST - Create a new TD line
    * def tdCode = "3"
    * def newLine =
    """
        {
          "gfeCode": "GFE_11",
          "tdSource": "ONE TD"
        }
        """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    * print response
    * def tdItemId = $.tdItem.id
    * print 'TD Item Id:', tdItemId
    * def esvVersionId = $.esv.esvVersionId
    * print 'ESV Version Id is: ', esvVersionId

    #    PUT - update the created line
    * def reqData =
    """
     {
      "tsv": {
        "genericPartCode": "R1750064-",
        "knownBomLegacyAllianceMasterPartNumber": true,
        "knownOneDicoGenericPartCode": true,
        "createdAt": "2021-09-17T07:18:14.840Z",
        "createdByIpn": "P094235"
      },
      "tsvItem": {
        "coleaderFlag": true,
        "commonalityType": "AC2_COMMON_2PARTS",
        "companyMembership": "RENAULT",
        "currentWeight": 0,
        "knownBomLegacyFinalPartNumber": true,
        "knownBomLegacyLinkedPartNumber": true,
        "legacyWeight": 0,
        "legacyWeightType": "AUTOMATICALY_CALCULATED",
        "partComment": "part number update",
        "partEep": true,
        "partFromAcm": true,
        "partKind": "ALLIANCE_MASTER_PART",
        "partModule": true,
        "partNameEn": "TUBE-FUEL RETURN",
        "partNameFr": "CANALISATION RETOUR CARBURANT",
        "partNumber": "175526967R",
        "partStatus": "BA",
        "unitOfUse": "CENTIMETER",
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param esvVersionId = esvVersionId
    And request reqData
    When method put
    Then status 200
    And match response == '#present'
    * print response

    #    Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'

