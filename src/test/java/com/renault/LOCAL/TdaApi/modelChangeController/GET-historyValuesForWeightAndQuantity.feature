Feature: As a tda client, I want to get the history values for weight and quantity for the given a tdCode, a GFE_Code, and a date

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Given a tdCode, a GFE_Code, and a date then returns history values for weight and quantity
   #Request to gets first project code with type PLATFORM and company RENAULT
    Given path '/api/v1/technical-definitions/'
    When method get
    Then status 200
    * def platform = karate.jsonPath(response, "$.technicalDefinitions[?(@.type=='VEHICLE' && @.company=='RENAULT')]")[0]
    * match platform == '#present'
    * def TDCode = platform.code
    # Generate date in ISO string format
    * def getDate =
      """
      function() {
        var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
        var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        var date = new java.util.Date();
        return sdf.format(date);
      }
      """
    * def currentDate = getDate()
    * def pageSize = 10

   #Given a tdCode, a GFE_Code, and a date then returns history values for weight and quantity
    Given path '/api/v2/query/technical-definition-model-change/snapshot'
    And param date = currentDate
    And param gfeCode = "GFE_11"
    And param tdCode = 3
    And param page = 1
    And param size = pageSize
    When method get
    And configure readTimeout = 500000
    Then status 200
    * match platform == '#present'



