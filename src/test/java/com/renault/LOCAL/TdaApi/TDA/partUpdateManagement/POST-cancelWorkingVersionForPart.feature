Feature: As a tda client, I want to cancel working version for Part.

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario Outline: POST - cancel working version for Part.


    # Update a platform TD (Patch)
    * def tdCode = 3
    * def partCancelWorkReq =
    """
    {
      "name": <name>,
      "company": <company>,
      "comment": '#(comment)',
      "businessProject": {
        "projectCode": <prjCode>,
        "projectName": <prjName>
      },
        "platformProject": {
          "familyCode": <familyCode>,
          "subplatformName": <subPlatFormName>
        },
        "platformVersion": {
          "batchNumber": <batchNumber>
        }
    }
    """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines/part-solutions/part-modification-cancellation'
    And request partCancelWorkReq
    When method post
    Then status <patchStatus>
    And match response == '#present'

    Examples:
      |name|company|prjCode|prjName|familyCode|subPlatFormName|batchNumber|status|expected|patchStatus|
      |'#(Name)'|"RENAULT"|"54YORON75F"|"XCC_HCC_DOUAI"|"XJB"|"Test Sub Platform Name"|"1"|201|postResponse |204|
