#@ignore
#Tested by TDPTF-1021
Feature: As a tda api client, i want to get the history of requested attribute for tsvItemId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Fetch history of requested attribute for tsvItemId

    #Request to get first PLATFORM code
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM'&&@.site=='ALL')]")[0]
    * match platform == '#notnull'
    * def platformTdCode = platform.code
    * print 'platform td code:', platformTdCode


	#Request to get platform id
    Given path '/api/v1/technical-definitions/code', platformTdCode
    When method get
    Then status 200
    * def platformTdId = $.id
    * print 'platform td id:', platformTdId

    * def sleep =
        """
        function(seconds){
          for(i = 0; i <= seconds; i++)
          {
            java.lang.Thread.sleep(1*1000);
            karate.log(i);
          }
        }
        """

    # Get Td lines by tdId
    Given path '/api/v1.1/technical-definitions/', platformTdId ,'/technical-definition-lines'
    And params {page: 0, size: 5000}
    And param gfeCodes = "GFE_12"
    When method get
    And call sleep 5
    Then status 200
    And match response  ==  '#present'
    * def tdLine = karate.jsonPath(response, "$.content")[0]
    * def tsvItemId = karate.jsonPath(tdLine, "ts.tsvItem.id")
    * print tsvItemId

    Given path '/api/v1/technical-definitions/technical-solution-variant-item/', tsvItemId
    And param column = <columnName>
    When method get
    Then status 200
    And match response  ==  '#present'
#   *  print response

    Examples:
      | columnName |
      |'quantity'|
      |'unitOfUse'|
      |'issueNumber'|
      |'designUpdateSheetNumber'|

