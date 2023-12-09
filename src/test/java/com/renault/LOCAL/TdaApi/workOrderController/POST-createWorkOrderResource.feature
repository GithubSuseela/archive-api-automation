Feature: As a tda client, I want to Create Work Order

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: POST - 200 - Create Work Order
    # Create a new line
    * def tdCode = 3
    * def requestData =
       """
        {
        "gfeCode": "GFE_11",
        "tdSource": "ONE TD"
        }
       """
    Given path '/api/v1/technical-definitions/', tdCode ,'/lines'
    And request requestData
    When method post
    Then status 201
    And match response == '#present'
    * def platformTdItemId = $.tdItem.id
    * print 'platform td item id:', platformTdItemId

    * def workOrderReqData =
    """
    {
    "workOrderRequests": [
      {
    "comment": "create WO test",
    "countryMarking": "",
    "creatingInductor1": "CUST_EXPECT_VEHICLES_AND_POWERTRAIN",
    "creatingInductor2": "ACOUSTIC_PERFORMANCE",
    "designTypology": "DESIGN_3D",
    "linkedPart": "",
    "mdsManagement": "NO",
    "rse": "PQE",
    "tdItemId": #(platformTdItemId),
    "type": "BOM_UPDATE",
    "unitOfUse": "CENTIMETER"
      }
     ]
    }
    """
    Given path '/api/v1/work-orders'
    And request workOrderReqData
    When method post
    Then status 201
    And match response == '#present'

