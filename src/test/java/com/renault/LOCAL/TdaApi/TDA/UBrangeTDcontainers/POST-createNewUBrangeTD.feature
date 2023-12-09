Feature: As a tda client, I want to Create a new UB Range TD with the specified properties

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Create a new UB Range TD with the specified properties

# Pre-requisite : Role should be TD_ADMIN_RENAULT for Renault and TD_ADMIN_NISSAN for Nissan
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
    * def comment =  "create UB range TD - " + " " + random_string(5)
    * def ranName = random_string(5) + " " + "Range Name"
    * def Name = random_string(5) + " " + "Name"
    * def reqData =
    """
       {
          "businessProject": {
            "projectCode": <prjCode>,
            "projectName": <prjName>
          },
          "comment": '#(comment)',
          "company": <Company>,
          "frontRunner": <frontRunner>,
          "name": '#(Name)',
          "ubRangeProject": {
            "familyCode": <famCode>,
            "rangeName": '#(ranName)'
          }
        }
    """
    * def resp =
    """
    {
      "createdTechnicalDefinition": {
        "tdCode": #number
      }
    }
    """
    Given path '/api/v1/ub-range-technical-definitions'
    And request reqData
    When method post
    Then status 201
    And match response == '#present'
    And match response == <expected>

    Examples:
      |prjCode|prjName|Company|famCode|expected|frontRunner|
      |"54YORON75F"|"XCC_HCC_DOUAI"|"RENAULT"|XJB  |resp|'test|
      |"54YORON75F"|"XCC_HCC_DOUAI"|"NISSAN"|XJB  |resp |'test1|