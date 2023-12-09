@ignore
Feature:
  Background:
    * url api_url
    * configure headers = callonce read('classpath:headers.js')

Scenario:
  Given path 'api/v1/node-insertion'
  And def body = {"solutionNumber": '#(solutionNumber)', "toPosition": { "position": '#(position)', "relativeTo": { "nodePath": #(targetNodePath) } } }
  And  request body
  When method POST
  Then status 200