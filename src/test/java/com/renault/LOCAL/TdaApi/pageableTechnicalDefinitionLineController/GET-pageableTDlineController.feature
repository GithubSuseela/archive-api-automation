Feature: As a tda api client, i want to fetch TD Lines By Page with its corresponding ESV and TSV data based on the tdId

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 -  Fetch TD Lines By Page with its corresponding ESV and TSV data based on the tdId

    # GET tdId
    Given path '/api/v1/technical-definitions'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM' && @.company=='RENAULT')]")[0]


    Given path '/api/v1/technical-definitions/details'
    And param code = platform.code
    When method get
    Then status 200
    And def tdId = response.tdId

    # Get TD lines by page
    Given path '/api/v1.1/technical-definitions/', tdId ,'/technical-definition-lines'
    And param pageSize = 10
    And param paged = 'true'
    And param sort.sorted = 'true'
    And param statuses = 'DRAFT'
    When method get
    Then status 200
    And match response  ==  '#present'







