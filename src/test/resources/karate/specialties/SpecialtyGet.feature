Feature: Get Specialty API (GET /specialties/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Get specialty successfully returns 200 with valid ID
    # First, create a specialty to test with
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Now test getting the created specialty
    Given path 'specialties', specialtyId
    When method GET
    Then status 200
    * assert response.id == specialtyId
    * assert response.name == 'Test Specialty'

  Scenario: Get specialty returns 404 with invalid ID
    Given path 'specialties', 99999
    When method GET
    Then status 404

  Scenario: Get specialty returns 404 with negative ID
    Given path 'specialties', -1
    When method GET
    Then status 404

  Scenario: Get specialty returns 404 with zero ID
    Given path 'specialties', 0
    When method GET
    Then status 404

  Scenario: Get specialty returns 404 with null ID
    Given path 'specialties', null
    When method GET
    Then status 404

  Scenario: Get specialty returns 404 with string ID
    Given path 'specialties', 'invalid'
    When method GET
    Then status 404

  Scenario: Get specialty returns 404 with decimal ID
    Given path 'specialties', 1.5
    When method GET
    Then status 404

  Scenario: Get specialty with invalid authentication returns 401
    Given path 'specialties', 1
    * header Authorization = 'Basic invalid_credentials'
    When method GET
    Then status 401

  Scenario: Get specialty without authentication returns 401
    Given path 'specialties', 1
    * header Authorization = null
    When method GET
    Then status 401

  Scenario: Get specialty with malformed URL returns 404
    Given path 'specialties/invalid/extra'
    When method GET
    Then status 404

  Scenario: Get specialty with trailing slash returns 200
    # First, create a specialty to test with
    Given path 'specialties'
    And request { name: 'Test Specialty 2' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Test getting with trailing slash
    Given path 'specialties', specialtyId, '/'
    When method GET
    Then status 200
