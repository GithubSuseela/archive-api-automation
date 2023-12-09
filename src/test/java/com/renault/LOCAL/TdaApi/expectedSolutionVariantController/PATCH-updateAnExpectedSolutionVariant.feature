Feature: As a tda client, I want to update an expected solution variant

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 200 Updates an expected solution variant
   # Create a new line
    * def tdCode = 3
    * def requestData =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def lineId = $.esv.lineId
    * def scopPart = $.esv.scopePart
    * def esvId = $.esv.id
    * def esvVersionId = $.esv.esvVersionId
    * def createdAt = $.esv.createdAt
    * def createdByIpn = $.esv.createdByIpn

    * def esvReqData =
    """
      {
      "tdCode": <TDCode>,
      "lineId": "<LineID>",
      "functionCode": "<funCode>",
      "functionDesignationEn": "<funDesignationEN>",
      "functionDesignationFr": "<funDesignationFR>",
      "gfeCode": "<GFECode>",
      "gfeDesignationEn": "<gfeDesignationEN>",
      "gfeDesignationFr": "<gfeDesignationFR>",
      "scopePart": "<ScopePart>",
      "initVehicle": "<initVeh>",
      "initPart": "<iniPart>",
      "unitCode": "<utCode>",
      "fatherPart": "<FatherPart>",
      "assemblyLevel": <assyLvl>,
      "sourceId": "<SourceId>",
      "quantity": <Quantity>,
      "projectTdCode": <PrjTDCode>,
      "nissanFunctionCode": "<NissanFunCode>",
      "nissanFunctionDesignationEn": "<NissanFunDesignationEN>",
      "bpName": "<BPName>",
      "bpAddInfo": "<BPAddInfo>",
      "addBpName": "<addBPName>",
      "knownBomLegacyInitPart": true,
      "departmentCode": "<deptCode>",
      "shippingUnit": "ORDER_LEVEL",
      "createdAt": '#(createdAt)',
      "createdByIpn": '#(createdByIpn)'
      }
    """
    Given path '/api/v1/expected-solution-variants/', esvVersionId
    And request esvReqData
    When method patch
    Then status 200
    And match response == '#present'

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'

    Examples:
      |TDCode|LineID|funCode|funDesignationEN|funDesignationFR|GFECode|gfeDesignationEN|gfeDesignationFR|ScopePart|initVeh|iniPart|utCode|FatherPart|assyLvl|SourceId|Quantity|PrjTDCode|NissanFunCode|NissanFunDesignationEN|BPName|BPAddInfo|addBPName|deptCode|
      |#(tdCode)|#(lineId)|F10473---|FR BMPR FASCIA & BRKT|PEAU DE BOUCLIER AV|GFE_11 |SUPERSTRUCTURE  |SUPERSTRUCTURE  |#(scopPart)|       |       |SV    |          |0      |         |0    ||             |                      |      |         |         |        |