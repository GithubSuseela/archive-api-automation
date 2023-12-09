@ignore
#Tested by TDPTF-1055
Feature: As a tda api client, I want to get the user editor rights by ipn

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  Fetch the user editor rights by ipn
    # Get the user ipn
    Given path '/api/v1/users/me'
    When method get
    Then status 200
    And match response  ==  '#present'
    * def ipn = response.ipn

    # Get the user editor rights by ipn
    Given path '/api/v1/users/', ipn ,'/editor-rights'
    When method get
    Then status 200
    And match response  ==  '#present'

