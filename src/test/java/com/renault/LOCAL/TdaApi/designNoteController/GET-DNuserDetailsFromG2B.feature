@ignore
#Tested by TDPTF-973
Feature: As a tda api client, I want to get the User details from g2b

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline:  Fetch the User details from g2b

    Given path '/api/v1/design-notes/g2b/user'
    And param email = '<Email>'
    When method get
    Then status 200
    And match response  ==  '#present'

   Examples:
    |Email|
    |masakazu-h@mail.nissan.co.jp|

