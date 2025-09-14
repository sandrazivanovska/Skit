Feature: Update Pet Type API (PUT /pettypes/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Update pet type successfully returns 204 with valid data
    Given path 'pettypes', 2
    And request { id: 2, name: 'Updated Pet Type' }
    When method PUT
    Then status 204

  Scenario: Update pet type with negative ID returns 400 (API validates ID field)
    Given path 'pettypes', -1
    And request { id: -1, name: 'Updated Name' }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'
    * assert response.detail.indexOf('must be greater than or equal to 0') >= 0

  Scenario: Update pet type without ID in path returns 500 (API throws HttpRequestMethodNotSupportedException)
    Given path 'pettypes'
    And request { id: 1, name: 'Updated Name' }
    When method PUT
    Then status 500
    * assert response.title == 'HttpRequestMethodNotSupportedException'

  Scenario: Update pet type with string ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'pettypes', 'invalid'
    And request { id: 1, name: 'Updated Name' }
    When method PUT
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Update pet type with decimal ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'pettypes', 1.5
    And request { id: 1, name: 'Updated Name' }
    When method PUT
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Update pet type with missing name field returns 400 (API validates name field)
    Given path 'pettypes', 3
    And request { id: 3 }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update pet type with null name returns 400 (API validates name field)
    Given path 'pettypes', 4
    And request { id: 4, name: null }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update pet type with empty name returns 400 (API validates name field)
    Given path 'pettypes', 5
    And request { id: 5, name: '' }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update pet type with very long name returns 400 (API validates name field)
    Given path 'pettypes', 6
    And request { id: 6, name: 'This is a very long pet type name that exceeds the maximum allowed length for the name field in the database schema and should trigger a validation error' }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update pet type with special characters in name returns 204
    Given path 'pettypes', 7
    And request { id: 7, name: 'Updated-Type_123!@#' }
    When method PUT
    Then status 204

  Scenario: Update pet type with numeric name returns 204
    Given path 'pettypes', 8
    And request { id: 8, name: '456' }
    When method PUT
    Then status 204

  Scenario: Update pet type with invalid authentication returns 204 (API doesn't require auth)
    Given path 'pettypes', 9
    And request { id: 9, name: 'Updated Name' }
    * header Authorization = 'Basic invalid_credentials'
    When method PUT
    Then status 204

  Scenario: Update pet type without authentication returns 204 (API doesn't require auth)
    Given path 'pettypes', 10
    And request { id: 10, name: 'Updated Name' }
    * header Authorization = null
    When method PUT
    Then status 204

  Scenario: Update pet type with malformed JSON returns 500 (API throws HttpMessageNotReadableException)
    Given path 'pettypes', 11
    And request '{"id": 11, "name": "Updated Name", "invalid": }'
    When method PUT
    Then status 500
    * assert response.title == 'HttpMessageNotReadableException'

  Scenario: Update pet type with wrong content type returns 204 (API accepts any content type)
    Given path 'pettypes', 12
    And request { id: 12, name: 'Updated Name' }
    * header Content-Type = 'text/plain'
    When method PUT
    Then status 204
