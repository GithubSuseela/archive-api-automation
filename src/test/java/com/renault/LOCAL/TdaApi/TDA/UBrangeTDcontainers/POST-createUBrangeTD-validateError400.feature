Feature: As a tda client, When I create Upper Body range TD and mandatory attributes are empty raise 400 error with the right message

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 400 - Raise 400 error when mandatory fields are empty

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
          "comment": <comment>,
          "company": <Company>,
          "frontRunner": <frontRunner>,
          "name": <name> ,
          "ubRangeProject": {
            "familyCode": <famCode>,
            "rangeName": <rangeName>
          }
        }
    """
    * def resp1 = {"errors": [{ "errorCode": "BAD_REQUEST", "errorMessage": "The Project Code is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    * def resp2 = {"errors": [{ "errorCode": "BAD_REQUEST", "errorMessage": "The Project Name is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    * def resp3 = {"errors": [{ "errorCode": "BAD_REQUEST", "errorMessage": "The Company is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    * def resp4 = {"errors": [{ "errorCode": "BAD_REQUEST", "errorMessage": "The Name is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    * def resp5 = {"errors": [{ "errorCode": "BAD_REQUEST", "errorMessage": "The Family Code is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    * def resp6 = {"errors": [{ "errorCode": "BAD_REQUEST", "errorMessage": "The Range Name is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}

    Given path '/api/v1/ub-range-technical-definitions'
    And request reqData
    When method post
    Then status 400
    And match response == '#present'
    And match response == <expected>

    Examples:
      |prjCode|prjName|Company|famCode|comment|name|rangeName|frontRunner|expected|
      |null|"XCC_HCC_DOUAI"|"RENAULT"|XJB  |'#(comment)'|'#(Name)'|'#(ranName)'|'Test'|resp1|
      |"54YORON75F"|null|"NISSAN"|XJB  |'#(comment)' |'#(Name)'|'#(ranName)'|'Test'|resp2|
      |"54YORON75F"|"XCC_HCC_DOUAI"|null|XJB  |'#(comment)'|'#(Name)'|'#(ranName)'|'Test'|resp3|
      |"54YORON75F"|"XCC_HCC_DOUAI"|"NISSAN"|XJB  |'#(comment)' |null|'#(ranName)'|'Test'|resp4|
      |"54YORON75F"|"XCC_HCC_DOUAI"|"RENAULT"|null  |'#(comment)'|'#(Name)'|'#(ranName)'|'Test'|resp5|
      |"54YORON75F"|"XCC_HCC_DOUAI"|"NISSAN"|XJB  |'#(comment)' |'#(Name)'|null|'Test'|resp6|