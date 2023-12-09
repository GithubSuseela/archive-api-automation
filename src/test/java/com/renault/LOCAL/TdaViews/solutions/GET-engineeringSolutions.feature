Feature: As a tda api client, I want to Search engineering solutions that match a set of search criteria.

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')


  Scenario Outline: GET - 200 - Search engineering solutions that match a set of search criteria.

    Given path '/api/v1/engineering-solutions'
    And param genericPartCode = <gpCode>
    And param masterPartId = <masterPId>
    And param technicalDiversity = <techDiversity>
    And param partId = <PartId>
    And param linkedPartId = <linkPartId>
    And param associatedPartId = <associatedPartId>
    And param limit = <paginationLimit>
    When method get
    Then status 200
    And match response  ==  '#present'
    * print response
#    And match $..lines[*].lifecycle contains {"milestoneCode": "#string", "maturityLevel": "#string", "version": "#string"}

    Examples:
    |gpCode|masterPId|techDiversity|PartId|linkPartId|associatedPartId|paginationLimit|
    |'F10159/AA'|''       |''           |''    |''        |''              |100|
    |'L2430003A'|''       |''           |''    |''        |''              |1000|
    |'R1700005-'|''       |''           |''    |''        |''              |100|
    |'A3200001-'|''       |''           |''    |''        |''              |100|