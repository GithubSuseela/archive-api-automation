Feature: As a tda api client, I want to get the Assembly by esvId and compare it with bom part response

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Fetch the Assembly details by esvId and compare it with bom part response

    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    And def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='PLATFORM')]")[0]

    Given path '/api/v1/technical-definitions/code/', platform.code
    When method get
    Then status 200
    And def platformId = response.id
#    And match platformId == '#present'

    Given path '/api/v1.1/technical-definitions/', platformId, '/technical-definition-lines'
    When method get
    Then status 200
    And match response == '#present'
#    * print response
    And def tdLines = karate.jsonPath(response, "$.content[?(@.assemblyPosition=='PART_OF')]")[0]
    And match tdLines == '#present'
#    * print tdLines
    And def esvId = karate.jsonPath(tdLines, "esv.id")
    And match esvId == '#present'
    * print esvId
    And def partNo = karate.jsonPath(tdLines, "ts.tsvItem.partNumber")
    And match partNo == '#present'
    * print partNo

    Given path '/api/v1/assemblies', esvId ,'/bom-part-structures'
    And param partNumber = partNo
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response
