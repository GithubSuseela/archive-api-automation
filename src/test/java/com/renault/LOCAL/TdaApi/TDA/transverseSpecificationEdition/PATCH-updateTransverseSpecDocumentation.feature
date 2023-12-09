Feature: As a tda client, I want to update the documentation of a Transverse Specification

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: PATCH - 200 - update the documentation of a Transverse Specification

    #Request to get first PLATFORM code
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def vehicle = karate.jsonPath(response, "$.vehicleTechnicalDefinitions")[0]
    And def platform = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
#    And def ubRange = karate.jsonPath(response, "$.platformTechnicalDefinitions")[0]
#    * print platform
#    * print vehicle
    * match platform  ==  '#present'
    * match vehicle  ==  '#present'
    * def vehicleCode = vehicle.tdCode
    * def platformCode = platform.tdCode

#   POST - Create a new TD line
    * def newLine =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', platformCode ,'/lines'
    And request newLine
    When method post
    Then status 201
    And match response == '#present'
    * def tdItemId = $.tdItem.id
    * print 'TD ItemId:', tdItemId
    * def lineId = $.esv.lineId
    * print 'Line Id: ', lineId
#    Update the documentation of the transverse specification
    * def updateDoc =
       """
        {
          "transverseDocumentation": {
            "freeDesignation": "Front right wheel",
            "note": "To be reviewed"
          },
          "requestedBy": "z014082",
          "updatedByIpn": "z014082"
        }
       """
    Given path '/api/v1/technical-definitions/', platformCode ,'/lines/', lineId ,'/transverse-documentation'
    And request updateDoc
    When method patch
    Then status 200
#    * print response

## Delete the created line
    Given path '/api/v1/technical-definition-lines/', tdItemId
    When method delete
    Then status 204
    And match response == '#present'

