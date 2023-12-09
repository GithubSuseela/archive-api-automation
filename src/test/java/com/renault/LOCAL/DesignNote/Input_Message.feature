Feature: Functionality of view input message

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:
    Given path '/v1/input-messages'
    And method GET
    Then status 200
    * print response
