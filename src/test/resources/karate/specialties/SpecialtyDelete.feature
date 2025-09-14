Feature: Delete Specialty API (DELETE /specialties/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Delete specialty successfully returns 204 with valid ID
    # First, create a specialty to delete
    Given path 'specialties'
    And request { name: 'Specialty to Delete' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Now delete the specialty
    Given path 'specialties', specialtyId
    When method DELETE
    Then status 204
    
    # Verify the specialty is deleted by trying to get it
    Given path 'specialties', specialtyId
    When method GET
    Then status 404

  Scenario: Delete specialty returns 404 with invalid ID
    Given path 'specialties', 99999
    When method DELETE
    Then status 404

  Scenario: Delete specialty returns 404 with negative ID
    Given path 'specialties', -1
    When method DELETE
    Then status 404

  Scenario: Delete specialty returns 404 with zero ID
    Given path 'specialties', 0
    When method DELETE
    Then status 404

  Scenario: Delete specialty returns 404 with null ID
    Given path 'specialties', null
    When method DELETE
    Then status 404

  Scenario: Delete specialty returns 404 with string ID
    Given path 'specialties', 'invalid'
    When method DELETE
    Then status 404

  Scenario: Delete specialty returns 404 with decimal ID
    Given path 'specialties', 1.5
    When method DELETE
    Then status 404

  Scenario: Delete already deleted specialty returns 404
    # First, create a specialty
    Given path 'specialties'
    And request { name: 'Specialty to Delete Twice' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Delete it first time
    Given path 'specialties', specialtyId
    When method DELETE
    Then status 204
    
    # Try to delete it again
    Given path 'specialties', specialtyId
    When method DELETE
    Then status 404

  Scenario: Delete specialty with invalid authentication returns 401
    Given path 'specialties', 1
    * header Authorization = 'Basic invalid_credentials'
    When method DELETE
    Then status 401

  Scenario: Delete specialty without authentication returns 401
    Given path 'specialties', 1
    * header Authorization = null
    When method DELETE
    Then status 401

  Scenario: Delete specialty with malformed URL returns 404
    Given path 'specialties/invalid/extra'
    When method DELETE
    Then status 404

  Scenario: Delete specialty with trailing slash returns 204
    # First, create a specialty to delete
    Given path 'specialties'
    And request { name: 'Specialty with Trailing Slash' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Delete with trailing slash
    Given path 'specialties', specialtyId, '/'
    When method DELETE
    Then status 204
