Feature: As a tda client, I want to change the application of a transverse specification to a specified TD

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Propose to change the application of a transverse specification to a specified TD

    * def reqData =
    """
       {
        "lineNumber": <LineNo>,
        "proposedApplication": <ProposedApp>,
        "proposedForTechnicalDefinitionCode": <ProposedForTD>
        }
    """
    Given path '/api/v1/technical-definitions/', <TDCode> ,'/applications/application-proposal'
    And request reqData
    When method post
    Then status 200
    And match response == '#present'

    Examples:
      |TDCode|LineNo|ProposedApp|ProposedForTD|
      |3    |"3-49604"|"FIRST_APP"|45          |