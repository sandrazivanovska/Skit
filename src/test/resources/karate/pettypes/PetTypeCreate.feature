Feature: Create Pet Type API (POST /pettypes)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Create pet type successfully returns 201 with valid data
    Given path 'pettypes'
    And request { name: 'New Pet Type' }
    When method POST
    Then status 201
    * assert response.id != null
    * assert response.name == 'New Pet Type'
    * assert responseHeaders.Location != null

  Scenario: Create pet type with empty name returns 400
    Given path 'pettypes'
    And request { name: '' }
    When method POST
    Then status 400

  Scenario: Create pet type with null name returns 400
    Given path 'pettypes'
    And request { name: null }
    When method POST
    Then status 400

  Scenario: Create pet type without name field returns 400
    Given path 'pettypes'
    And request { }
    When method POST
    Then status 400

  Scenario: Create pet type with very long name returns 400
    Given path 'pettypes'
    And request { name: 'This is a very long pet type name that exceeds the maximum allowed length for the name field in the database schema and should trigger a validation error' }
    When method POST
    Then status 400

  Scenario: Create pet type with special characters in name returns 201
    Given path 'pettypes'
    And request { name: 'Pet-Type_123!@#' }
    When method POST
    Then status 201
    * assert response.name == 'Pet-Type_123!@#'

  Scenario: Create pet type with whitespace only name returns 201 (API allows it)
    Given path 'pettypes'
    And request { name: '   ' }
    When method POST
    Then status 201
    * assert response.name == '   '

  Scenario: Create pet type with numeric name returns 201
    Given path 'pettypes'
    And request { name: '123' }
    When method POST
    Then status 201
    * assert response.name == '123'

  Scenario: Create pet type with duplicate name returns 201 (API allows duplicates)
    # First create a pet type
    Given path 'pettypes'
    And request { name: 'Duplicate Name' }
    When method POST
    Then status 201
    * def firstId = response.id
    
    # Try to create another with same name
    Given path 'pettypes'
    And request { name: 'Duplicate Name' }
    When method POST
    Then status 201
    * assert response.id != firstId

  Scenario: Create pet type with invalid authentication returns 201 (API doesn't require auth)
    Given path 'pettypes'
    And request { name: 'Test Pet Type' }
    * header Authorization = 'Basic invalid_credentials'
    When method POST
    Then status 201

  Scenario: Create pet type without authentication returns 201 (API doesn't require auth)
    Given path 'pettypes'
    And request { name: 'Test Pet Type' }
    * header Authorization = null
    When method POST
    Then status 201

  Scenario: Create pet type with malformed JSON returns 500 (API throws exception)
    Given path 'pettypes'
    And request '{"name": "Test Pet Type", "invalid": }'
    When method POST
    Then status 500
    * assert response.title == 'HttpMessageNotReadableException'

  Scenario: Create pet type with different content type returns 201 (API accepts any content type)
    Given path 'pettypes'
    And request { name: 'Test Pet Type' }
    * header Content-Type = 'text/plain'
    When method POST
    Then status 201
