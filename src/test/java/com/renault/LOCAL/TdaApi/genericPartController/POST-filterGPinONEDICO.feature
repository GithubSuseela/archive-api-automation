@ignore
#Tested by TDPTF-1013
Feature: As a tda api client, i want to  filter GP in One Dico

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  POST - 200 - Filter gpCode in One Dico

#    Fetch GP code and Family
    Given path '/api/v1/work-orders'
    And param status = 'OPEN'
    When method get
    Then status 200
    And def resp =  karate.jsonPath(response, "$.workOrderResources")[0]

#    Fetch nameFr and nameEn
    Given path '/api/v1/generic-parts'
    And param gpCode = resp.genericPartCode
    When method get
    Then status 200
    And match response  ==  '#present'
    And def gpNameEn = response.nameEn
    And def gpNameFr = response.nameFr

#    Filter gpCode in One Dico
    * def searchQuery =
    """
        {
          "fields": [
            "gpCode",
            "activeBasicPart" ,
            "allianceCommodityModuleCode",
            "commentEn",
            "commentFr",
            "creationDate",
            "gpCode",
            "isStandardized",
            "kind",
            "nameEn",
            "nameFr",
            "nissanFunction",
            "pictureBase64FileString",
            "pictureFileName",
            "renaultFunction",
            "renaultModuleCode",
            "renaultRPMBreakdown",
            "renaultRPMBreakdownNameEn",
            "renaultRPMBreakdownNameFr"
              ],
          "gpCode": #(resp.genericPartCode),
          "limit": 10,
          "nameFr": #(gpNameFr),
          "nameEn": #(gpNameEn),
          "familyCode": #(resp.family)
        }
    """
    Given path '/api/v1/generic-parts'
    And request searchQuery
    When method post
    Then status 200
    And match response == '#present'
