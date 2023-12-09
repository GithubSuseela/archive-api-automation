Feature: As a tda api client, I want to create or update Td Line with provided line data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  POST - 200 - Import TD item and Line status

   # Get Platform code
    Given path '/api/v1/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
    And def tdCode = platform.tdCode
    * print "Td Code: ",tdCode

    # Create a new Line
    * def requestData = {"gfeCode": "GFE_11", "tdSource": "ONE TD"}
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def lineNumber = $.esv.lineId
    * print "Line Number: ",lineNumber
    * def esvId = $.esv.id
    * print 'ESV Id: ', esvId

    # Import TD item data for created (existing) line
    * def reqData =
    """
    {
      "lineData": [
        {
          "columnKey": "LINE_ID",
          "value": #(lineNumber)
        },
        {
          "columnKey": "EE_DEVELOPMENT_TYPE",
          "value": "CO_HW_SW"
        },
        {
          "columnKey": "EXPECTED_DMU_CODE",
          "value": "MANUFACTURING_APPROVAL"
        },
        {
          "columnKey": "SOURCING_COUNTRY",
          "value": "India"
        },
        {
          "columnKey": "MAKE_OR_BUY_CODE",
          "value": "MAKE_OUT"
        },
        {
          "columnKey": "SUPPLY_LOCALISATION",
          "value": "test supply localisation"
        },
        {
          "columnKey": "RISK_OPPORTUNITY",
          "value": "RISK"
        },
        {
          "columnKey": "FORECAST_USE_CASE",
          "value": "BJA/RV"
        },
        {
          "columnKey": "INIT_DIVERSITY",
          "value": "1"
        },
        {
          "columnKey": "TARGET_DIVERSITY",
          "value": "2"
        },
        {
          "columnKey": "CURRENT_DIVERSITY",
          "value": "3"
        },
        {
          "columnKey": "MILESTONE",
          "value": "SERIES"
        },
        {
          "columnKey": "GENERIC_PART_CODE_IN_BOM",
          "value": "F10179/AD"
        },
        {
          "columnKey": "SMA_ID",
          "value": "test SMA"
        },
        {
          "columnKey": "SOURCING_COMPETITION",
          "value": "WITH_COMPETITION"
        },
        {
          "columnKey": "SOURCING_BATCH",
          "value": "test sourcing batch"
        },
        {
          "columnKey": "USER_COMMENT",
          "value": "test comment"
        },
        {
          "columnKey": "TOOLING_SCHEDULE",
          "value": "XL"
        },
        {
          "columnKey": "ITEM_STATUS",
          "value": "DRAFT"
        },
        {
          "columnKey": "COCA",
          "value": "GREEN"
        }
      ]
    }
    """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/line-import'
    And request reqData
    When method post
    Then status 200

    * def expectedResponse =
    """
     {
        "makeOrBuy": "MAKE_OUT",
        "genericPartCode": "F10179/AD",
        "cocaStatus": "GREEN",
        "initDiversity": 1,
        "currentDiversity": 3,
        "targetDiversity": 2,
        "expectedDmu": "MANUFACTURING_APPROVAL",
        "itemMilestoneCode": "SERIES",
        "eeDevelopmentType": "CO_HW_SW",
        "supplyLocalisation": "test supply localisation",
        "riskOpportunity": "RISK",
        "genericPartNameEn": "TUBE-BRAKE, DIRECT BRAKE AMPL & FR WHEEL, SECD",
        "userComment": "test comment",
        "genericPartNameFr": "TUYAU SECONDAIRE DE FREIN ENTRE ADF ET ROUE AV",
        "toolingSchedule": "XL",
        "forecastDiversity": "BJA/RV",
        "status": "DRAFT"
      }
    """
#    Verify the imported data in the td line
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And param esvLineIds = lineNumber
    When method get
    Then status 200
    And match response  ==  '#present'
    And match $.tdLines[0].tdItem contains expectedResponse

    #   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'