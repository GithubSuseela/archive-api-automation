@ignore
#Tested by TDPTF-1052
Feature: As a tda api client, I want to get the TSV Item details based on final part number

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  GET - 200 - Fetch TSV Item details based on final part number

    * def fpn = '751757868R'
    * def expected =
      """
      {
        "thickness": '#string',
        "rse": '#string',
        "partNameFr": "LONGERON CTL G SOUS PLANCHER",
        "legacyWeightType": '#string',
        "partRevisionStatus": '#string',
        "designTypology": '#string',
        "companyMembership": "RENAULT",
        "partRevisionLevel": '#string',
        "uvTreatment": '#string',
        "partStatus": '#string',
        "updatedAt": '#string',
        "legacyWeight": '#number',
        "currentWeight": '#number',
        "partKind": '#string',
        "partNameEn": "MBR-CTR LH SIDE, UNDER FLOOR",
        "commonalityType": '#string',
        "partNumber": "751757868R",
        "unitOfUse": '#string'
      }
      """
    Given path '/api/v1/technical-solution-variant-items/final-part-number', fpn
    When method get
    Then status 200
    And match response  contains  expected
#    * print response