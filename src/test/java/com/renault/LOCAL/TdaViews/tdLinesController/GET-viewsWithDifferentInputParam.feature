Feature: As a tda api client, I want to Find latest versions of Technical Definition Lines matching various specified search criteria

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario Outline: GET - 200 - Find latest versions of TD Lines matching different specified search criterias

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = <tdCode>
    And param gfeCode = <GfeCode>
    And param lineNumber = <lineNo>
    And param pivotNumber = <pivotNo>
    And param maturityLevel = <maturityLvl>
    And param gpCode = <GpCode>
    And param partId = <PartId>
    And param cadItemId = <CadItemId>
    And param engineeringItemId = <engItemId>
    And param withApplicationDetails = <withAppDetails>
    And param onlyWhenApplicationDefined = <onlyWhenAppDefined>
    And param modifiedSince = <modSince>
    And param applicationPolicy = <AppPolicy>
#    And param fromTechnicalDefinitionCode = <fromTdCode>
#    And param afterLineNumber = <afterLineNo>
    And param limit = <paginationLimit>
    And param requestedBy = <reqBy>
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response

    Examples:
    |tdCode|GfeCode|lineNo|pivotNo|maturityLvl|GpCode|PartId|CadItemId|engItemId|withAppDetails|onlyWhenAppDefined|modSince|AppPolicy|paginationLimit|reqBy|
    |3    |11      |''    |''     |'DRAFT'    |''    |''    |''       |''       |false         |false             |''      |'ACTIVE_APPLICATIONS'|10|'z014082'|
    |3    |11      |''    |''     |'RTU'      |''    |''    |''       |''       |false         |false             |''      |'ACTIVE_APPLICATIONS'|100|'z014082'|
    |3    |11      |''    |''     |'PUBLISHED'|''    |''    |''       |''       |false         |false             |''      |'ACTIVE_APPLICATIONS'|1000|'z014082'|
    |3    |11      |''    |''     |'RELEASED' |''    |''    |''       |''       |false         |false             |''      |'ACTIVE_APPLICATIONS'|10|'z014082'|
    |3    |11      |''    |''     |'DEACTIVATED'|''  |''    |''       |''       |false         |false             |''      |'ACTIVE_APPLICATIONS'|100|'z014082'|
    |3    |11      |''    |''     |''    |''  |''    |''       |''       |false         |false             |''      |'NO_APPLICATION'|1000|'z014082'|
    |3    |11      |''    |''     |''    |''  |''    |''       |''       |false         |false             |''      |'ALL_APPLICATIONS'|10|'z014082'|
    |3    |11      |''    |''     |''    |''  |''    |''       |''       |false         |false             |''      |'ACTIVE_AND_PROPOSED_APPLICATIONS'|100|'z014082'|
    |3    |11      |''    |''     |''    |'R6780003-'|''|''       |''       |false         |false             |''      |''|1000|'z014082'|
    |3    |11      |''    |''     |''    |''  |'751757868R'|''       |''       |false         |false             |''      |''|10|'z014082'|
    |3    |''      |''    |''     |''    |''    |''    |''       |''       |true         |true             |''      |''|''|'z014082'|


