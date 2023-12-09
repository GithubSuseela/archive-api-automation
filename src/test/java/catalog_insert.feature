@ignore
Feature:
  Background:
    * url api_url
    * configure headers = callonce read('classpath:headers.js')

  Scenario:
    Given path 'api/v1/assembly-catalogs'
    And  request {"catalogName": '#(catalogName)', "catalogPerimeter": {"technicalDefinitionCodes": #(tdCodes)}}
    When method POST
    Then status 201
    And assert response != null
    And match $.catalogCreated.catalogNumber == '#present'
