Feature: Create Specialty API (POST /specialties)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Create specialty successfully returns 201 with valid data
    Given path 'specialties'
    And request { name: 'New Specialty' }
    When method POST
    Then status 201
    * assert response.id != null
    * assert response.name == 'New Specialty'
    * assert responseHeaders.Location != null

  Scenario: Create specialty with empty name returns 400
    Given path 'specialties'
    And request { name: '' }
    When method POST
    Then status 400

  Scenario: Create specialty with null name returns 400
    Given path 'specialties'
    And request { name: null }
    When method POST
    Then status 400

  Scenario: Create specialty without name field returns 400
    Given path 'specialties'
    And request { }
    When method POST
    Then status 400

  Scenario: Create specialty with very long name returns 400
    Given path 'specialties'
    * def longName = 'A'.repeat(100)
    And request { name: longName }
    When method POST
    Then status 400

  Scenario: Create specialty with special characters in name returns 201
    Given path 'specialties'
    And request { name: 'Specialty-123!@#' }
    When method POST
    Then status 201
    * assert response.name == 'Specialty-123!@#'

  Scenario: Create specialty with whitespace only name returns 400
    Given path 'specialties'
    And request { name: '   ' }
    When method POST
    Then status 400

  Scenario: Create specialty with numeric name returns 201
    Given path 'specialties'
    And request { name: '123' }
    When method POST
    Then status 201
    * assert response.name == '123'

  Scenario: Create specialty with duplicate name returns 201 (if allowed) or 409
    Given path 'specialties'
    And request { name: 'Duplicate Specialty' }
    When method POST
    Then status 201
    * def firstId = response.id

    Given path 'specialties'
    And request { name: 'Duplicate Specialty' }
    When method POST
    * assert responseStatus == 201 || responseStatus == 409

  Scenario: Create specialty with invalid authentication returns 401
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    * header Authorization = 'Basic invalid_credentials'
    When method POST
    Then status 401

  Scenario: Create specialty without authentication returns 401
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    * header Authorization = null
    When method POST
    Then status 401

  Scenario: Create specialty with malformed JSON returns 400
    Given path 'specialties'
    And request '{"name": "Test Specialty", "invalid": }'
    When method POST
    Then status 400

  Scenario: Create specialty with wrong content type returns 400
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    * header Content-Type = 'text/plain'
    When method POST
    Then status 400
