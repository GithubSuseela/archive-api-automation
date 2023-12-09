Feature: As a tda client, I want to Get the part structure components from catalogue

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: GET - 200 - Part structure components from catalogue

    * def errorNotFound =
    """
      {
      "code": 404,
      "message": "part-id is not found"
      }
     """
  #   Get the part structure components from catalogue
    Given path '/api/v1/part-structure-components'
    And param version = <Version>
    And param partId = <PartId>
    And param requestedBy = <reqBy>
    When method get
    Then status <Status>
    And match response == <expected>

    Examples:
      |Version|PartId|reqBy|Status|expected|
      |'LAST_ACTIVE_VERSION'|'7703072426'|'z014082'|200|'#present'|
      |'LAST_ACTIVE_VERSION'|'751007789R'|'z014082'|200|'#present'|
      |'LAST_ACTIVE_VERSION'|'1234567896'|'z014082'|404|errorNotFound|
#      |'WORKING_VERSION'    |'7703072426'|'z014082'|200| -- working version not implemented