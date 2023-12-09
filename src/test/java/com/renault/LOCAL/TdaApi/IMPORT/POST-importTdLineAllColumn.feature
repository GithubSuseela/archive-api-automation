Feature: As a tda api client, I want to create or update Td Line with provided line data

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  POST - 201 - Import TD line with all column values (Need to update script)

    * def reqData =
    """
    {
      "requestedBy": "z014082",
      "lineData": [
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
    * def tdCode = 3
    * def resp1 = {"lineCreated": {"lineNumber": "#string", "technicalDefinitionCode": "#number"}}
    * def resp2 = {"error": "Not Found"}
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/line-import'
    And request reqData
    When method post
    Then status 201
    And match response  ==  '#present'
    * print response
    * def lineId = $..lineCreated.lineNumber
    * print lineId
#    And match response contains <expected>



