Feature: As a tda client, I want to Create a Power Train TD Container

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Create a Power Train TD Container

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
    * def comment =  "create UB range TD - " + random_string(5)
    * def Name = "PWT TD Name - " + random_string(5)
    * def reqData =
    """
    {
      "name": <name>,
      "company": <company>,
      "comment": '#(comment)',
      "businessProject": {
        "projectCode": <prjCode>,
        "projectName": <prjName>
      },
      "pwtProject": {
        "site": <site>,
        "pwtFamilyTdCode": <pwtFamilyTdCode>
      },
      "nextMilestone": {
        "milestoneCode": <milestoneCode>
      }
    }
    """

    # Success scenario ( Status - 201) with valid values
    * def resp1 = {"createdTechnicalDefinition": {"tdCode": #number}}
    # Error 400 - Name attribute is missing
    * def resp2 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The TD Name is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Company attribute is missing
    * def resp3 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Company is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Project code attribute is missing
    * def resp4 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Project Code is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Project Name attribute is missing
    * def resp5 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Project Name is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Site attribute is missing
    * def resp6 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Site is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - PWT Family Td Code attribute is missing
    * def resp7 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The PowerTrain Family TD Code is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Milestone code attribute is missing
    * def resp8 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Milestone Code is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Invalid company code (Other than Renault/Nissan)
    * def resp9 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Company is not valid", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 404 - Invalid pwtFamilyTdCode
    * def resp10 = {"errors": [{"errorCode": "PWT_FAMILY_TD_NOT_FOUND", "errorMessage": "The specified Power Train Family TD could not be found", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "PWT_FAMILY_TD_NOT_FOUND"}
    # Error 400 - Invalid Milestone code
    * def resp11 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Milestone Code is not valid", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}

    Given path '/api/v1/pwt-technical-definitions'
    And request reqData
    When method post
    Then status <status>
    And match response == '#present'
    And match response == <expected>

    Examples:
      |name|company|prjCode|prjName|site|pwtFamilyTdCode|milestoneCode|status|expected|
#      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|223|"INTENTION"|201|resp1 |
      |''|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|223|"INTENTION"|400|resp2 |
      |'#(Name)'|null|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|223|"INTENTION"|400|resp3 |
      |'#(Name)'|"RENAULT"|""|"XCC_HCC_DOUAI"|"DOUAI"|223|"INTENTION"|400|resp4 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|""|"DOUAI"|223|"INTENTION"|400|resp5 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|""|223|"INTENTION"|400|resp6|
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|null|"INTENTION"|400|resp7 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|2|null|400|resp8 |
      |'#(Name)'|"Test"|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|223|"INTENTION"|400|resp9 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|10121|"INTENTION"|404|resp10 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"DOUAI"|223|"Test"|400|resp11 |