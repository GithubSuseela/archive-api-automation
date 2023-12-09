Feature: As a tda client, I want to Create a Platform TD Container

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST & PATCH - Create & Update a Platform TD Container

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
    * def comment =  "create platform TD - " + random_string(5)
    * def Name = "Test PF TD Name - " + random_string(5)
    * def postReqData =
    """
    {
      "name": <name>,
      "company": <company>,
      "comment": '#(comment)',
      "businessProject": {
        "projectCode": <prjCode>,
        "projectName": <prjName>
      },
        "platformProject": {
          "familyCode": <familyCode>,
          "subplatformName": <subPlatFormName>
        },
        "platformVersion": {
          "batchNumber": <batchNumber>
        }
    }
    """

    # Create a platform TD (POST)
    * def postResponse = {"createdTechnicalDefinition": {"tdCode": #number}}
    Given path '/api/v1/pwt-technical-definitions'
    And request postReqData
    When method post
    Then status <status>
    And match response == '#present'
    And match response == <expected>
    * def tdCode = $.createdTechnicalDefinition.tdCode

    # Update a platform TD (Patch)
    * def patchReqData =
    """
    {
      "name": <name>,
      "company": <company>,
      "comment": '#(comment)',
      "businessProject": {
        "projectCode": <prjCode>,
        "projectName": <prjName>
      },
        "platformProject": {
          "familyCode": <familyCode>,
          "subplatformName": <subPlatFormName>
        },
        "platformVersion": {
          "batchNumber": <batchNumber>
        }
    }
    """
    Given path '/platform-technical-definitions/', tdCode
    And request patchReqData
    When method post
    Then status <patchStatus>
    And match response == '#present'

    Examples:
      |name|company|prjCode|prjName|familyCode|subPlatFormName|batchNumber|status|expected|patchStatus|
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"XJB"|"Test Sub Platform Name"|"1"|201|postResponse |204|
