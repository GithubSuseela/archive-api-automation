@ignore
#Tested by TDPTF-1154
Feature: As a tda client, I want to deactivate a technical definition line

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Deactivate a technical definition line

#   POST - Create a new TD line
    * def tdCode = "<TDCode>"
    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    * def esvId = $.esv.id

#   POST - Deactivate the created line
    * def deactivateReq =
    """
      {
        "expectedSolutionVariantId": #(esvId),
        "technicalDefinitionCodes": [
          #(tdCode)
        ]
      }
    """
    Given path '/api/v1/technical-definition-lines/deactivate'
    And request deactivateReq
    When method post
    Then status 200
    And match response == '#present'
    And match $.status == 'SUCCESS'

    Examples:
      |TDCode|
      |3     |
