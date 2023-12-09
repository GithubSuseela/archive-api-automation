Feature: As a tda client, I want to update the work order resource attributes by work order id

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: PATCH - 200 - update the work order resource attributes by work order id

    # Create a new line (Parent)
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

    # POST - Create Work Order
    * def workOrderReqData =
    """
    {
    "workOrderRequests": [
      {
    "comment": "create WO test",
    "countryMarking": "",
    "creatingInductor1": "CUST_EXPECT_VEHICLES_AND_POWERTRAIN",
    "creatingInductor2": "ACOUSTIC_PERFORMANCE",
    "designTypology": "DESIGN_3D_MODEL_MANDATORY",
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
    * def workOrderId = $.workOrderResources[0].id

    # PATCH - Update Work Order status
    * def patchWOReqData =
      """
      {
      "status": "IN_PROGRESS"
      }
      """
    Given path '/api/v1/work-orders/', workOrderId
    And request patchWOReqData
    When method patch
    Then status 200
    And match response == '#present'
    And assert response.status == "IN_PROGRESS"
