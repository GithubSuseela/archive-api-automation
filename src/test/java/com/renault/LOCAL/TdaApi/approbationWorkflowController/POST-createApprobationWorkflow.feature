Feature: As a tda client, I want to create approbation workflow

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Creation of approbation workflow with proposals and lines involved

    * def RequestData =
    """
      {
       "approbationType": <ApprobationType>,
       "approbationNumber": <ApprobationNumber>,
       "approbationStatus": <ApprobationStatus>,
       "proposals": [
         {
           "proposalNumber": <ProposalNumber>,
           "proposalStatus": <ProposalStatus>,
           "proposalType": <ProposalType>,
           "technicalDefinitionCode": <TDCode>,
           "lineNumbers": <LineNumbers>
         }
        ]
      }
    """
    Given path '/api/v1/technical-definitions/', <TDCode>  ,'/approbation-workflows'
    And request RequestData
    When method post
    Then status 201
    And match response == '#present'
    * print response

    Given path '/api/v1/technical-definitions/', <TDCode> ,'/approbation-workflows/', <ApprobationType> ,'/', <ApprobationNumber> ,'/proposals/', <ProposalNumber> ,'/lines/', <LineNumbers>
    And request {}
    When method delete
    Then status 204
    And match response == '#present'

    Examples:
      |ApprobationType|ApprobationNumber|ApprobationStatus|ProposalNumber|ProposalStatus|TDCode|LineNumbers|ProposalType|
      |'APPLICABILITY_VALIDATION'|1       |'PROPOSED'     |1            |'PROPOSED'     |3     |["3-230"]|'APPLICABILITY'|
      |'APPLICABILITY_VALIDATION'|1       |'PROPOSED'     |1            |'PROPOSED'     |3     |["3-230"]|'PLATFORM_LINE'|
      |'APPLICABILITY_VALIDATION'|1       |'PROPOSED'     |1            |'PROPOSED'     |3     |["3-230"]|'APPLICABILITY_REMOVAL'|