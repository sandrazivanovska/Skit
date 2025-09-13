Feature: Update Owner API (PUT /owners/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Update owner successfully returns 204 with valid data
    Given path 'owners', 5
    And request { id: 5, firstName: 'Updated John', lastName: 'Updated Doe', address: '456 Updated St', city: 'Updated City', telephone: '5559999' }
    When method PUT
    Then status 204

  Scenario: Update owner with negative ID returns 500 (API throws ConstraintViolationException)
    Given path 'owners', -1
    And request { id: -1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method PUT
    Then status 500
    * assert response.title == 'ConstraintViolationException'
    * assert response.detail.indexOf('must be greater than or equal to 0') >= 0

  Scenario: Update owner without ID in path returns 500 (API throws HttpRequestMethodNotSupportedException)
    Given path 'owners'
    And request { id: 1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method PUT
    Then status 500
    * assert response.title == 'HttpRequestMethodNotSupportedException'

  Scenario: Update owner with string ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'owners', 'invalid'
    And request { id: 1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method PUT
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Update owner with decimal ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'owners', 1.5
    And request { id: 1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method PUT
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Update owner with missing required fields returns 400 (API validates required fields)
    Given path 'owners', 2
    And request { id: 2, firstName: 'John' }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update owner with null required fields returns 400 (API validates required fields)
    Given path 'owners', 3
    And request { id: 3, firstName: null, lastName: null, address: null, city: null, telephone: null }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update owner with empty required fields returns 400 (API validates required fields)
    Given path 'owners', 4
    And request { id: 4, firstName: '', lastName: '', address: '', city: '', telephone: '' }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update owner with very long fields returns 400 (API validates field lengths)
    Given path 'owners', 5
    And request { id: 5, firstName: 'This is a very long first name that exceeds the maximum allowed length for the firstName field in the database schema and should trigger a validation error', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method PUT
    Then status 400
    * assert response.title == 'MethodArgumentNotValidException'

  Scenario: Update owner with special characters returns 400 (API enforces validation)
    Given path 'owners', 6
    And request { id: 6, firstName: 'Updated-John', lastName: 'Updated-Doe', address: '456 Updated St #4B', city: 'Updated City, NY', telephone: '555-9999' }
    When method PUT
    Then status 400

  Scenario: Update owner with numeric fields returns 400 (API enforces name patterns)
    Given path 'owners', 7
    And request { id: 7, firstName: '123', lastName: '456', address: '789', city: '012', telephone: '555-9999' }
    When method PUT
    Then status 400

  Scenario: Update owner with invalid authentication returns 204 (API doesn't require auth)
    Given path 'owners', 8
    And request { id: 8, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    * header Authorization = 'Basic invalid_credentials'
    When method PUT
    Then status 204

  Scenario: Update owner without authentication returns 204 (API doesn't require auth)
    Given path 'owners', 9
    And request { id: 9, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    * header Authorization = null
    When method PUT
    Then status 204

  Scenario: Update owner with malformed JSON returns 500 (API throws HttpMessageNotReadableException)
    Given path 'owners', 10
    And request '{"id": 10, "firstName": "John", "lastName": "Doe", "invalid": }'
    When method PUT
    Then status 500
    * assert response.title == 'HttpMessageNotReadableException'

  Scenario: Update owner with wrong content type returns 204 (API accepts any content type)
    Given path 'owners', 11
    And request { id: 11, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    * header Content-Type = 'text/plain'
