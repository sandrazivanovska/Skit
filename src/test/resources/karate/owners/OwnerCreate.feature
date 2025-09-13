Feature: Create Owner API (POST /owners)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Create owner successfully returns 201 with valid data
    Given path 'owners'
    And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method POST
    Then status 201
    * assert response.id != null
    * assert response.firstName == 'John'
    * assert response.lastName == 'Doe'
    * assert response.address == '123 Main St'
    * assert response.city == 'Anytown'
    * assert response.telephone == '5551234'
    * assert responseHeaders.Location != null

  Scenario: Create owner with missing required fields returns 400
    Given path 'owners'
    And request { firstName: 'John' }
    When method POST
    Then status 400

  Scenario: Create owner with empty required fields returns 400
    Given path 'owners'
    And request { firstName: '', lastName: '', address: '', city: '', telephone: '' }
    When method POST
    Then status 400

  Scenario: Create owner with null required fields returns 400
    Given path 'owners'
    And request { firstName: null, lastName: null, address: null, city: null, telephone: null }
    When method POST
    Then status 400

  Scenario: Create owner with very long fields returns 400
    Given path 'owners'
    And request { firstName: 'This is a very long first name that exceeds the maximum allowed length for the firstName field in the database schema and should trigger a validation error', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method POST
    Then status 400

  Scenario: Create owner with special characters returns 400 (API enforces validation)
    Given path 'owners'
    And request { firstName: 'John-O\'Connor', lastName: 'Doe-Smith', address: '123 Main St #4B', city: 'New York, NY', telephone: '555-1234' }
    When method POST
    Then status 400

  Scenario: Create owner with numeric fields returns 400 (API enforces name patterns)
    Given path 'owners'
    And request { firstName: '123', lastName: '456', address: '789', city: '012', telephone: '555-1234' }
    When method POST
    Then status 400

  Scenario: Create owner with invalid authentication returns 201 (API doesn't require auth)
    Given path 'owners'
    And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    * header Authorization = 'Basic invalid_credentials'
    When method POST
    Then status 201

  Scenario: Create owner without authentication returns 201 (API doesn't require auth)
    Given path 'owners'
    And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    * header Authorization = null
    When method POST
    Then status 201

  Scenario: Create owner with malformed JSON returns 500 (API throws exception)
    Given path 'owners'
    And request '{"firstName": "John", "lastName": "Doe", "invalid": }'
    When method POST
    Then status 500
    * assert response.title == 'HttpMessageNotReadableException'

  Scenario: Create owner with wrong content type returns 201 (API accepts any content type)
    Given path 'owners'
    And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    * header Content-Type = 'text/plain'
    When method POST
    Then status 201
