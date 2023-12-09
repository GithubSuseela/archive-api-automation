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
           "technicalDefinitionCode": <TDCode>,
           "lineNumbers": <LineNumbers>
         }
        ]
      }
    """
    Given path '/api/v1/technical-definitions/', <TDCode>  ,'/approbation-workflows'
    And request RequestData
    When method post
    Then status <postStatus>
    And match response == '#present'
#    * print response

    * def deleteResp1 = '#string'
    * def deleteResp = {"code": 400, "description": "It is not possible to delete a proposal related to approbation workflow with status different from PROPOSED", "message": "Bad Request"}
    Given path '/api/v1/technical-definitions/', <TDCode> ,'/approbation-workflows/', <ApprobationType> ,'/', <ApprobationNumber> ,'/proposals/', <ProposalNumber> ,'/lines/', <LineNumbers>
    And request {}
    When method delete
    Then status <deleteStatus>
    And match response == <deleteExpected>
#    * print response

    Examples:
      | ApprobationType            | ApprobationNumber | ApprobationStatus | ProposalNumber | ProposalStatus | TDCode | LineNumbers |postStatus|deleteStatus|deleteExpected|
      | 'APPLICABILITY_VALIDATION' | 1                 | 'PROPOSED'        | 1              | 'PROPOSED'     | 3      | ["3-230"]   |201       |204         |deleteResp1 |
      | 'APPLICABILITY_VALIDATION' | 1                 | 'SUBMITTED'       | 1              | 'SUBMITTED'    | 3      | ["3-231"]   |201       |400         |deleteResp |
      | 'APPLICABILITY_VALIDATION' | 1                 | 'VALIDATED'       | 1              | 'VALIDATED'    | 3      | ["3-229"]   |201       |400         |deleteResp |
      | 'APPLICABILITY_VALIDATION' | 1                 | 'CANCELLED'       | 1              | 'CANCELLED'    | 3      | ["3-236"]   |201       |400         |deleteResp |
      | 'APPLICABILITY_VALIDATION' | 1                 | 'REJECTED'        | 1              | 'REJECTED'     | 3      | ["3-243"]   |201       |400         |deleteResp |
