Feature: As a tda api client, I want to Check Td lines using Parts populated in BOM with Country Marking and Conception Leader

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario Outline: Check Td lines using Parts populated in BOM with Country Marking and Conception Leader

    Given path '/api/v1/technical-definition-lines/authored-lines'
    And param technicalDefinitionCode = <tdCode>
#    And param partId = <PartId>
    And param applicationPolicy = <AppPolicy>
    And param limit = 100
    When method get
    Then status <Status>
    And match response  ==  '#present'
#    * print response
    And match $..lines[*].transverseSpecification.partSolution.part.conceptionLeader == '#present'
    And match $..lines[*].transverseSpecification.partSolution.part.countryMarkingCode == '#present'

#    And def CLNotNull = karate.jsonPath(response, "$.lines[?(@.transverseSpecification.partSolution.part.conceptionLeader!='')]")
#    * print CLNotNull
#    And def CMCNotNull = karate.jsonPath(response, "$.lines[?(@.transverseSpecification.partSolution.part.countryMarkingCode!='')]")
#    * print CMCNotNull
#    And match $..lines[*].transverseSpecification.partSolution.part.conceptionLeader contains <ConceptionLeader>
#    And match $..lines[*].transverseSpecification.partSolution.part.countryMarkingCode contains <CountryMarkingCode>

    Examples:
    |tdCode|AppPolicy|PartId|Status|ConceptionLeader|CountryMarkingCode|
    |3     |'ACTIVE_APPLICATIONS'|'284429143R'|200|'RENAULT'|'CCC'     |
#    |3     |'ACTIVE_APPLICATIONS'|'901242604R'|200|'NISSAN'|''|
