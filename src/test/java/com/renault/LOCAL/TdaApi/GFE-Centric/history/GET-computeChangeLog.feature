Feature: As a tda client, I want to fetch the change log for each required attribute

  Background:
    * url api_url
    * configure headers = read('classpath:headers.js')

  Scenario: GET - 200 - Compute ChangeLog

    Given path '/api/v2/query/technical-definition-changes'
    And param tdCode = 3
    And param transverseSpecificationId = '849aa923-eb2a-4a33-ae51-72c105147d8e'
    And param attributes = 'genericPartCode'
    When method get
    Then status 200
    And match response  ==  '#present'
    And print response
#    * print response
#    And match response[*].tsvi contains {"finalPartNumber":"#string","partEep":"#boolean","legacyWeight":"#number","currentWeight":"#number","finalPartKind":"#string","material":"#string","partNote":"#string","finalPartDesignationFr":"#string","knownBomLegacyFinalPartNumber":"#boolean","commonalityType":"#string","id":"#string","finalPartDesignationEn":"#string","unitOfUse":"#string"}

    #### Sample RESPONSE    ##
#  {
#  "tdCode": 3,
#  "changesLog": [
#  {
#  "transverseSpecificationId": "bb198149-8f2c-4827-ad05-b2c3aaab85fa",
#  "changes": [
#  {
#  "name": "status",
#  "stateLog": [
#  {
#  "value": "DRAFT",
#  "updatedAt": "2022-04-29T04:46:19.418Z",
#  "updatedBy": "awboy01",
#  "revision": "16190861",
#  "revisionId": "36e50729-4516-4d03-8d28-c51dd22ff795",
#  "changeType": "UPDATE"
#  },