@ignore
Feature:
  Background:
    * url api_url
    * configure headers = callonce read('classpath:headers.js')

Scenario:
  Given path 'api/v1/head-creation'
  And  request solutionNumber
  When method POST
  Then status 200