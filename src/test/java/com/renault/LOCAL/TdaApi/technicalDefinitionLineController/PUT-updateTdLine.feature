Feature: As a tda client, I want to update a Td Line with request values

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PUT - 201 - update a Td Line with request values
    #   POST - Create a new TD line
    * def tdCode = "<TDCode>"
    * def newLine =
    """
        {
          "gfeCode": "GFE_11",
          "tdSource": "DT PROJECT"
        }
        """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    #    * print response
    * def tdItemId = $.tdItem.id
    #    * print tdItemId


    #    PUT - update the created line
    * def req =
    """
        {
          "activeStatus": "<actStatus>",
          "applicabilityStatus": "<appStatus>",
          "cocaStatus": "GREEN",
          "currentDiversity": 0,
          "eeDevelopmentType": "CO_HW_SW",
          "expectedDmu": "SERIES",
          "forecastDiversity": "EAT,EIP",
          "initDiversity": 0,
          "itemStatus": "DRAFT",
          "makeOrBuy": "BUY",
          "originalVehicle": "XJB",
          "pivot0": true,
          "riskOpportunity": "RISK",
          "smaId": "3",
          "sourcingBatch": "1",
          "sourcingCompetition": "POE",
          "sourcingCountry": "",
          "supplyLocalisation": "",
          "targetDiversity": 0,
          "toolingSchedule": "XL",
          "updatedAt": "",
          "itemMilestoneCode": "SERIES",
          "updatedByIpn": "string",
          "userComment": "<usrComment>",
          "realDiversity": "",
          "companyMembership": "RENAULT",
    #      "genericPartCode": "<GPCode>",
    #      "genericPartNameEn": "<gpNameEN>",
    #      "genericPartNameFr": "<gpNameFR>"
        }
        """
    Given path '/api/v1/technical-definition-lines/', tdItemId
    And request req
    When method put
    Then status 201
    And match response == '#present'
    And match $.esv.genericSolution.genericPartCode == 'A1120002'
    And match $.esv.genericSolution.genericPartNameEn == 'INSUL ASSY-ENG MTG,RH'
    And match $.tdItem.userComment == 'update tdline test'


    #    Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'


    Examples:
    |TDCode|actStatus|appStatus|usrComment|GPCode|gpNameEN|gpNameFR|
    |3     |ACTIVE   |FIRST_APP|update tdline test|A1120002-|INSUL ASSY-ENG MTG,RH|TAMPON SUSPENSION D GMP ASS|
