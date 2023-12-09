Feature: As a tda client, I want to Create a new Power Train Family TD Container with the specified properties

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - Create a new Power Train Family TD Container with the specified properties

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
      "businessProject": {
        "projectCode": <prjCode>,
        "projectName": <prjName>
      },
      "comment": '#(comment)',
      "company": <company>,
      "name": <name>,
      "pwtFamilyProject": {
        "familyCode": <familyCode>,
        "pwtType": <pwtType>
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
    # Error 400 - Family Code is missing
    * def resp6 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Family Code is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - The Powertrain Type attribute is missing
    * def resp7 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Powertrain Type is mandatory", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Invalid company code (Other than Renault/Nissan)
    * def resp8 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Company is not valid", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}
    # Error 400 - Invalid Powertrain Type
    * def resp9 = {"errors": [{"errorCode": "BAD_REQUEST", "errorMessage": "The Powertrain Type is not valid", "errorLevel": "error", "errorType": "functional"}], "errorDescription": "BAD_REQUEST"}

    Given path '/api/v1/pwt-family-technical-definitions'
    And request reqData
    When method post
    Then status <status>
    And match response == '#present'
    And match response == <expected>

    Examples:
      |name|company|prjCode|prjName|familyCode|pwtType|status|expected|
#      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"XJB"|"ICE_ENGINE"|201|resp1 |
      |''|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|XJB|"ELECTRIC_ENGINE"|400|resp2 |
      |'#(Name)'|null|"54YORON75F"|"XCC_HCC_DOUAI"|XJB|"GEAR_BOX"|400|resp3 |
      |'#(Name)'|"RENAULT"|''|"XCC_HCC_DOUAI"|XJB|"REDUCER"|400|resp4 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|''|XJB|"TRACTION_BATTERY"|400|resp5 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|''|"TRACTION_BATTERY"|400|resp6|
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"XJB"|null|400|resp7 |
      |'#(Name)'|"Test"|"54YORON75F"|"XCC_HCC_DOUAI"|"XJB"|"ELECTRIC_ENGINE"|400|resp8 |
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"ABC"|"Test PWT type"|400|resp9 |