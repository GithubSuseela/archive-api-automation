Feature: As a tda api client, I want to update the TSV and tsvItem data through import for an existing TD line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  POST - 201 - Import valid TSV and TSV Item data for a existing line

    # Get Platform code
    Given path '/api/v1/technical-definitions'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
    And def tdCode = platform.tdCode
    * print "Td Code: ",tdCode
#    * print platform


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

    # Import TSV and TSV Item data for created (existing) line
    * def reqData =
    """
    {
      "requestedBy": "z014082",
      "lineData": [
        {
          "columnKey": "LINE_ID",
          "value": #(lineNumber)
        },
        {
          "columnKey": "EXPECTED_WEIGHT",
          "value": <expectedWeight>
        },
        {
          "columnKey": "CURRENT_WEIGHT",
          "value": <currentWeight>
        },
        {
          "columnKey": "PART_EE",
          "value": <partEE>
        },
        {
          "columnKey": "PART_KIND",
          "value": <partKind>
        },
        {
          "columnKey": "UNIT_OF_USE",
          "value": <unitOfUse>
        },
        {
          "columnKey": "LINKED_TYPE",
          "value": <linkedType>
        },
        {
          "columnKey": "PART_NUMBER",
          "value": <partNumber>
        },
        {
          "columnKey": "PART_NAME_EN",
          "value": <partNameEN>
        },
        {
          "columnKey": "PART_NAME_FR",
          "value": <partNameFR>
        },
        {
          "columnKey": "COMMONALITY_TYPE",
          "value": <commonalityType>
        },
        {
          "columnKey": "SUPPLIER",
          "value": <supplier>
        },
        {
          "columnKey": "MANUFACTURING_TYPOLOGY",
          "value": <manufacturingTypology>
        },
        {
          "columnKey": "MATERIAL_NAME",
          "value": <materialName>
        },
        {
          "columnKey": "THICKNESS",
          "value": <thick>
        },
        {
          "columnKey": "PROTECTION_VAL",
          "value": <protectVal>
        },
        {
          "columnKey": "PART_NOTE",
          "value": <partNote>
        },
        {
          "columnKey": "LINKED_PART",
          "value": <linkedPart>
        },
        {
          "columnKey": "TECHNICAL_DIVERSITY",
          "value": <techDiv>
        },
        {
          "columnKey": "OCI_NUMBER",
          "value": <ociNumber>
        },
        {
          "columnKey": "MASTER_PART",
          "value": <masterPart>
        },
        {
          "columnKey": "MASTER_PART_DESIGNATION_EN",
          "value": <materPartDesigEN>
        },
        {
          "columnKey": "MASTER_PART_DESIGNATION_EN",
          "value": <materPartDesigFR>
        }
      ]
    }
    """

    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/line-import'
    And request reqData
    When method post
    Then status <Status>
#    * print response
    * def tsvItemResponse =
    """
     {
          "thickness": "Test",
          "linkedPartNumber": "Renault",
          "linkedPartType": "REPLACEMENT",
          "partNameEn": "test EN designation",
          "partNameFr": "test FR designation",
          "partComment": "Test Note",
          "ociNumber": "9876543210",
          "supplier": "Test Supplier",
          "legacyWeight": 8.0,
          "currentWeight": 5.0,
          "partKind": "SINGLE_PART",
          "manufacturingTypology": "Test manufacturing Typology",
          "materialName": "Test Material",
          "commonalityType": "STRICT",
          "partNumber": "284423297R",
          "unitOfUse": "PART"
      }
    """

#    Verify the imported data in the td line
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And param esvLineIds = lineNumber
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response
    And match $.tdLines[0].ts.tsvItem contains <expected>

#   POST - Deactivate the created line
    * def deactivateReq = {"expectedSolutionVariantId": #(esvId), "technicalDefinitionCodes": [#(tdCode)]}
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'

    Examples:
      |expectedWeight|currentWeight|partEE|partKind|unitOfUse|linkedType|partNumber|partNameEN|partNameFR|commonalityType|supplier|manufacturingTypology|materialName|thick|protectVal|partNote|linkedPart|techDiv|ociNumber|masterPart|materPartDesigEN|materPartDesigFR|Status|expected|
      |8|5|"true"|"SINGLE_PART"|"PART"|"Replacement"|"284423297R"|"test EN designation"|"test FR designation"|"Strict"|"Test Supplier"|"Test manufacturing Typology"|"Test Material"|"Test"|"Test"|"Test Note"|"Renault"|"XJA"|"9876543210"|"ALMP18383R"|"9876543210"|"ALMP18383R"|200|tsvItemResponse|





