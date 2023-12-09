@ignore
#Tested by TDPTF-1027
Feature: As a tda api client, i want to filter parts in BOM legacy

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  To filter parts in BOM legacy

    Given path '/api/v1/parts'
    And param familyCode = 'PFE'
    When method get
    Then status 200
    And match response  ==  '#present'


