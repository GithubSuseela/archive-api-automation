Feature: Get user token from arca

    Scenario: Authentication
      Given url token_url
      And form field grant_type = 'password'
      And form field client_id = client_id
      And form field client_secret = client_secret
      And form field username = username
      And form field password = password
      And form field scope = scope
      When method post
      Then status 200
      
      * def access_token = response.access_token
      
      * print '[AUTHENTICATE] access_token', access_token
