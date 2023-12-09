Feature: As a tda api client, I want to get the list of technical definitions by familyCode

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  GET - 200 Fetch list of technical definitions by familyCode (optional)

    Given path '/api/v1/technical-definitions'
#    And param familyCode = '<FamilyCode>'
    And param type = '<Type>'
    And param code = '<Code>'
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response
#    And def expected1 =
#    """
#      "vehicleTechnicalDefinitions": [
#      {
#      "code": '#number',
#      "name": '#string',
#      "type": "VEHICLE",
#      "familyCode": '#string',
#      "body": '#string',
#      "site": '#string',
#      "company": '#string',
#      "comment": '#string',
#      "isEligibleForDigitalMockUp": '#boolean',
#      "createdAt": '#string',
#      "createdBy": '#string',
#      "modifiedAt": '#string',
#      "modifiedBy": '#string',
#      "projectName": '#string'
#    }
#    ]
#    """
#    And def expected2 =
#    """
#    "platformTechnicalDefinitions": [
#    {
#      "code": '#number',
#      "name": '#string',
#      "type": "PLATFORM",
#      "familyCode": '#string',
#      "body": '#string',
#      "site": '#string',
#      "company": '#string',
#      "comment": '#string',
#      "isEligibleForDigitalMockUp": '#boolean',
#      "createdAt": '#string',
#      "createdBy": '#string',
#      "modifiedAt": '#string',
#      "modifiedBy": '#string',
#      "projectCode": '#string',
#      "projectName": '#string'
#    }
#    ]
#    """
#    And def expected3 =
#    """
#    "platformTechnicalDefinitions": [
#    {
#      "tdCode": '#number',
#      "name": '#string',
#      "company": '#string',
#      "comment": '#string',
#      "isEligibleForDigitalMockUp": '#boolean',
#      "createdAt": '#string',
#      "createdBy": '#string',
#      "modifiedAt": '#string',
#      "modifiedBy": '#string',
#      "ubRangeProject": {
#        "familyCode": '#string',
#        "rangeName": '#string'
#      },
#      "businessProject": {
#        "projectCode": '#string',
#        "projectName": '#string'
#      },
#      "status": {
#        "isActive": '#boolean'
#      }
#    }
#    ]
#    """
#    And match response contains <expected>

    Examples:
    | FamilyCode |Type|Code|expected|
    | XJB |VEHICLE    |3   |expected1|
    | XJB |PLATFORM   |3   |expected2|
    | XJB |UB_RANGE   |3   |expected3|
