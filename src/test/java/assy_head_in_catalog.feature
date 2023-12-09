@ignore
Feature:
  Background:
    * url api_url
    * configure headers = callonce read('classpath:headers.js')

Scenario:
  Given path '/api/v1/assembly-catalogs/',catalogNumber,'/assemblies/assembly-creation'
  And request {"solutionNumber":'#(solutionNumber)'}
  When method post
  Then status 200
  And match response == '#present'