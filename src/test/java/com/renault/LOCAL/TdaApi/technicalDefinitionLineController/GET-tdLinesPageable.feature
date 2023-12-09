Feature: As a tda api client, I want to fetch TD Lines By Page with its corresponding ESV and TSV data based on the tdId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET 200 - Get TD Lines [Pageable]

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
    And call sleep 15
    Then status 200
    And match response  ==  '#present'
#    * print response
    * def tdLine = karate.jsonPath(response, "$.content")[0]
    * print tdLine
    And match tdLine contains {version: '#string'}
    And match response.. contains {bpName: '#string'}
    And match response.. contains {complementNameNumber: '#number'}
    And match response.. contains {standardNameNumber: '#number'}
