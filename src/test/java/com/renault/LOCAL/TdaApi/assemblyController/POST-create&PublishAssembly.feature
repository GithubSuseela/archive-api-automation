Feature: As a tda api client, I want to create an assembly and publish it to BOM if validation is ok

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario:  POST - 201 - Create & Submit Assembly to BOM

    # call create empty line (Parent)
    * def parentLine = call read('classpath:com/renault/LOCAL/TdaApi/assemblyController/POST-createEmptyLine.feature')
#    * print parentLine
    * def tdItemId = parentLine.response.tdItem.id
    * def esvParentId = parentLine.response.esv.id
    * def tdId = parentLine.response.id
    * print 'Esv id parent:' , esvParentId
    * print 'tdItemId :' , tdItemId
    * print 'Td id :' , tdId
    # call create empty line (child)
    * def childLine = call read('classpath:com/renault/LOCAL/TdaApi/assemblyController/POST-createEmptyLine.feature')
    * def esvChildId = childLine.response.esv.id
    * print 'Esv id child:' , esvChildId

        #    PATCH - update Technical Solution Variant Item for the created line
    * def reqData =
    """
     {
        "partNameEn": {
        "value": "TUBE-FUEL RETURN"
      },
        "partNameFr": {
        "value": "CANALISATION RETOUR CARBURANT"
      },
        "partNumber": {
        "value": "175526967R"
      }
    }
    """
    Given path '/api/v1/technical-solution-variant-items'
    And param tdItemId = tdItemId
    And request reqData
    When method patch
    Then status 200
    And match response == '#present'
#    * print response
#    * def latestUpdatedAt = $.tsvItem.updatedAt

    # Create Assembly
    * def assemblyReqData =
    """
      [{
        "coleaderFlag": true,
        "esvIdChild": '#(esvChildId)',
        "esvIdParent": '#(esvParentId)',
        "functionCode": "G10000---",
        "genericPartCode": "A1120002-",
        "genericPartNameEn": "INSUL ASSY-ENG MTG,RH",
        "genericPartNameFr": "TAMPON SUSPENSION D GMP ASS",
        "knownBomLegacyFinalPartNumber": true,
        "knownOneDicoGenericPartCode": true,
        "legacyWeight": 0,
        "partEep": true,
        "partKind": "ALLIANCE_MASTER_PART",
        "partNameEn": "KIT-1ST ROW SEAT",
        "partNameFr": "COLLECTION SIEGES 1ERE RNG",
        "partNumber": "860005857R",
        "quantity": 1,
        "row": 0,
        "shippingUnit": "DESIGN_LEVEL",
        "tdId": '#(tdId)',
        "tdItemId": '#(tdItemId)',
        "thickness": "1.1",
        "unitOfUse": "CENTIMETER",
        "wayOfManagement": "AUTOMATIC"
      }]
    """
    Given path '/api/v1/assemblies'
    And request assemblyReqData
    When method post
    Then status 201
    And match response  ==  '#present'
#    * print response
    # Verify the created assembly
    Given path '/api/v1/assemblies/', esvParentId ,'/children'
    When method get
    Then status 200
    And match response  ==  '#present'
#    * print response
    # Publish the created assembly to BOM
    * def assemblySubmitData =
    """
    {
      "esvId": '#(esvParentId)',
      "tdId": '#(tdItemId)'
    }
    """
    Given path '/api/v1/assemblies/submit'
    And request assemblySubmitData
    When method post
    Then status 201
    And match response  ==  '#present'
#    * print response



