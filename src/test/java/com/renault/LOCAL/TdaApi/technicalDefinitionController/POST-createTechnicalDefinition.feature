Feature: As a tda client, I want to create a technical definition

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 201 - creates a technical definition

#   POST - Create a Technical Definition
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
    * def comment =  "Test Comment" + ' ' + random_string(10)
    * def ProjectNAME =  "Test Project Name" + ' ' + random_string(10)
    * def pName =  random_string(4)
    * def init99 = random_string(99)
    * def init100 = random_string(100)
    * def init101 = random_string(101)
    * def tdReqData =
    """
    {
      "body": "<Body>",
      "comment": "<Comment>",
      "companyCode": "<compCode>",
      "family": "<Family>",
      "initVehicle": "<InitVeh>",
      "master": <Master>,
      "milestoneCode": "<MilestoneCode>",
      "name": "<Name>",
      "projectCode": "<PrjCode>",
      "projectName": "<PrjName>",
      "projectTdCode": <PrjTDCode>,
      "site": "<Site>",
      "type": "<Type>",
      "createdByIpn": "<createdBy>",
      "createdAt": "2021-01-11T16:13:13Z"
    }
    """
    Given path '/api/v1/technical-definitions'
    And request tdReqData
    When method post
    Then status 201
    And match response == '#present'

    Examples:
      |Body|Comment|compCode|Family|InitVeh|Master|MilestoneCode|Name|PrjCode|PrjName|PrjTDCode|Site|Type|createdBy|
      |B_HS AND B_LS|comment|RENAULT|PFJ|init100|true|COMPLETION|pName|1841|ProjectNAME|15|ALL|PLATFORM|Z014082|
#      |B_HS AND B_LS|#(comment)|RENAULT|PFJ|#(init100)|true|COMPLETION|#(pName)|1841|#(ProjectNAME)|13|ALL|PLATFORM|Z014082|
#      |B_HS AND B_LS|#(comment)|RENAULT|PFJ|#(random_string(100))|true|COMPLETION|#(Name)|1841|#(PrjNAME)|5|ALL |PLATFORM|Z014082|
#      |B_HS AND B_LS|#(comment)|RENAULT|PFJ|#(random_string(101))|true|COMPLETION|#(Name)|1841|#(PrjNAME)|6|ALL |PLATFORM|Z014082|
