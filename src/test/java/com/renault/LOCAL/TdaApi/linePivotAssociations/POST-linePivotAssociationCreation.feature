Feature: As a tda api client, I want to to associate /de-associate TD Lines with a  pivot I defined for my vehicle TD

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST/DELETE - Associate / De-associate TD Lines with a pivot I defined for my vehicle TD

    # Associate TD Line with a pivot I defined for my vehicle TD
    * def req = {"pivotNumber": '<pivotNo>'}
    * def resp1 = "#string"
    * def resp2 = {"code": 400, "message": "Bad Request", "description": "Association can not be created because TD line already associated to this Pivot"}

    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/', <lineNo> ,'/pivot-associations'
    And request req
    When method post
    Then status <Status>
    And match response == '#present'
    And match response == <expected>

    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/', <lineNo> ,'/pivot-associations/pivot-associations-history'
    When method get
    Then status 200
    And match response == '#present'
    * print response

    # De-associate TD Line with a pivot I defined for my vehicle TD
    * def response1 = "#string"
    Given path '/api/v1/technical-definitions/', <tdCode> ,'/lines/', <lineNo> ,'/pivot-associations/' , <pivotNo>
    And request {}
    When method delete
    Then status <Status1>
    And match response == <expected1>

    Examples:
      |pivotNo|lineNo|tdCode|Status|expected|Status1|expected1|
      |80     |'3-48789'|3    |201   |resp1   |204  |response1|