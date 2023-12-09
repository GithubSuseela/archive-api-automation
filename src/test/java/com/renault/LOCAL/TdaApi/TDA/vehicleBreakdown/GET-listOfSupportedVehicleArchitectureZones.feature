Feature: As a tda client, I want to get the list of supported vehicle architecture zones

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - list of supported vehicle architecture zones

#    * def vehArchZones =
#     """
#     [
#      {"code": "CMO", "nameFr": "Compartiment Moteur", "nameEn": "Engine Bay"},
#      {"code": "FAR", "nameFr": "Face Arrière", "nameEn": "Rear Face"},
#      {"code": "FAR_F", "nameFr": "Face Arrière Fournisseur", "nameEn": "Rear Face Supplier"},
#      {"code": "FAR_M", "nameFr": "Face Arrière Make", "nameEn": "Rear Face Make"},
#      {"code": "FAV", "nameFr": "Face Avant", "nameEn": "Front Face"},
#      {"code": "FAV_F", "nameFr": "Face Avant Fournisseur", "nameEn": "Front Face Supplier"},
#      {"code": "FAV_M", "nameFr": "Face Avant Make", "nameEn": "Front Face Make"},
#      {"code": "INL", "nameFr": "Intérieur Latéral", "nameEn": "Interior Side"},
#      {"code": "INP", "nameFr": "Plancher", "nameEn": "Interior - Floor"},
#      {"code": "INP_F", "nameFr": "Plancher Fournisseur", "nameEn": "Interior - Floor Supplier"},
#      {"code": "INP_M", "nameFr": "Plancher Make", "nameEn": "Interior - Floor Make"},
#      {"code": "LAT", "nameFr": "Face Latérale", "nameEn": "Side Face"},
#      {"code": "LAT_F", "nameFr": "Face Latérale Fournisseur", "nameEn": "Side Supplier"},
#      {"code": "LAT_M", "nameFr": "Face Latérale Make", "nameEn": "Side Make"},
#      {"code": "NC" },
#      {"code": "PDC", "nameFr": "Poste de Conduite", "nameEn": "Cockpit"},
#      {"code": "PDC_F", "nameFr": "Poste de Conduite Fournisseur", "nameEn": "Cockpit Supplier"},
#      {"code": "PDC_M", "nameFr": "Poste de Conduite Make", "nameEn": "Cockpit Make"},
#      {"code": "SCA", "nameFr": "Sous-Caisse", "nameEn": "UnderBody"}
#     ]
#     """
    * def vehArchZones =
      """
      [{"code":"CMO","nameFr":"Compartiment Moteur","nameEn":"Engine Bay"},{"code":"FAR","nameFr":"Face Arrière","nameEn":"Rear Face"},{"code":"FAV","nameFr":"Face Avant","nameEn":"Front Face"},{"code":"INL","nameFr":"Intérieur Latéral","nameEn":"Interior Side"},{"code":"INP","nameFr":"Plancher","nameEn":"Interior - Floor"},{"code":"LAT","nameFr":"Face Latérale","nameEn":"Side Face"},{"code":"PDC","nameFr":"Poste de Conduite","nameEn":"Cockpit"},{"code":"SCA","nameFr":"Sous-Caisse","nameEn":"UnderBody"}]
      """
    Given path '/api/v1/vehicle-architecture-zones'
    When method GET
    Then status 200
    And match response == '#present'
    And match response.vehicleArchitectureZones contains vehArchZones

