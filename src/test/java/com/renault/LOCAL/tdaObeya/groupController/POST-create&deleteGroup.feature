Feature: As a tda client, I want to create and delete a group

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - 200 - CREATE & DELETE group

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
    * def name =  "GN" + ' ' + random_string(10)

    # Create a Group
    * def createPayload =
    """
    {
      "name": "#(name)",
      "type": <grpType>,
      "kind": <kind>,
      "source": <source>,
      "validationOrderEnabled": <validOrderEnabled>,
      "technicalDefinitionCodes": [
        3
      ],
      "userIds": [
        "Z014082"
      ]
    }
    """
    Given path '/api/v1/groups/create-group'
    And request createPayload
    When method post
    Then status 200
    And match response == '#present'
    And def groups = karate.jsonPath(response, "$.events")[0]
#    * print groups
    And def groupId = groups.eventPayload.groupId
    * print 'Group ID: ', groupId

#    Delete the created Group

    * def deletePayload =
    """
    {
      "groupId": "#(groupId)"
    }
    """
    * def expected  =
    """
        {
      "events": [
        {
          "eventType": "group-deleted",
          "eventPayload": {
            "groupId": "#(groupId)"
          }
        }
      ]
    }
    """
    Given path '/api/v1/groups/delete-group'
    And request deletePayload
    When method post
    Then status 200
    And match response == '#present'
    And match response == expected

    Examples:
      |grpType|kind|source|validOrderEnabled|
      |'PFL' |"WORK_ORDER"|"BOY"|true       |
      |'APFL' |"WORK_ORDER"|"BOY"|true|