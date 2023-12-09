Feature: As a tda client, I want to Update Approbation Workflow Status

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Update Approbation Workflow Status

    * def RequestData =
    """
      {
      "transition": <TransitionStatus>
      }
    """
    Given path '/api/v1/technical-definitions/', <TDCode> ,'/approbation-workflows/', <ApprobationType> ,'/', <ApprobationNumber> ,'/transitions'
    And request RequestData
    When method post
    Then status <postStatus>
    And match response == '#present'
    * print response


    Examples:
      | ApprobationType            | ApprobationNumber | TransitionStatus | TDCode |postStatus|
      | 'APPLICABILITY_VALIDATION' | 1                 | "PROPOSED"        | 73    |201       |
      | 'APPLICABILITY_VALIDATION' | 1                 | "SUBMITTED"       | 73    |201       |
      | 'APPLICABILITY_VALIDATION' | 1                 | "VALIDATED"       | 73    |201       |
      | 'APPLICABILITY_VALIDATION' | 1                 | "CANCELLED"       | 73    |201       |

