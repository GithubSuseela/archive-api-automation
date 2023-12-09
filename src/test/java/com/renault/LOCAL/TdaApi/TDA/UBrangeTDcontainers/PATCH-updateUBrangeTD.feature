Feature: As a tda client, I want to Update an UB Range TD

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: PATCH - 204 - Update an UB Range TD

## Pre-requisite : Role should be TD_ADMIN_RENAULT for Renault and TD_ADMIN_NISSAN for Nissan
    * def random_string =
       """
       function(s) {
         var text = "";
         var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
         for (var i = 0; i < s; i++)
           text += possible.charAt(Math.floor(Math.random() * possible.length));
         return text;
       }
       """
    * def comment = "created UB range TD - " + " " + random_string(5)
    * def comment = "updated UB range TD - " + " " + random_string(5)
    * def ranName = "created Range Name - " + " " + random_string(5)
    * def ranName1 = "updated Range Name - " + " " + random_string(5)
    * def Name = "Post Name - " + " " + random_string(5)
    * def Name1 = "Patch Name - " + " " + random_string(5)
#    * def postReq =
#    """
#       {
#          "businessProject": {
#            "projectCode": <prjCode>,
#            "projectName": <prjName>
#          },
#          "comment": '#(comment)',
#          "companyCode": <compCode>,
#          "name": '#(Name)',
#          "ubRangeProject": {
#            "familyCode": <famCode>,
#            "rangeName": '#(ranName)'
#          }
#        }
#    """
#    Given path '/api/v1/ub-range-technical-definitions'
#    And request postReq
#    When method post
#    Then status 201
#    And match response == '#present'
#    * print response
#    * def tdCode = $.createdTechnicalDefinition.tdCode

    * def patchReq =
    """
       {
          "businessProject": {
            "projectCode": <prjCode>,
            "projectName": <prjName>
          },
          "comment": '#(comment1)',
          "companyCode": <compCode>,
          "name": '#(Name1)',
          "ubRangeProject": {
            "familyCode": <famCode>,
            "rangeName": '#(ranName1)'
          }
        }
    """
    Given path '/api/v1/ub-range-technical-definitions/', <tdCode>
    And request patchReq
    When method patch
    Then status 204
    And match response == '#present'

    Examples:
      |prjCode|prjName|compCode|famCode|tdCode|
      |"54YORON75F"|"XCC_HCC_DOUAI"|"RENAULT"|XJB  |174|
