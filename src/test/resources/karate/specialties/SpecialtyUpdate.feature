Feature: Update Specialty API (PUT /specialties/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Update specialty successfully returns 204 with valid data
    # First, create a specialty to update
    Given path 'specialties'
    And request { name: 'Original Specialty' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Now update the specialty
    Given path 'specialties', specialtyId
    And request { id: specialtyId, name: 'Updated Specialty' }
    When method PUT
    Then status 204
    
    # Verify the update by getting the specialty
    Given path 'specialties', specialtyId
    When method GET
    Then status 200
    * assert response.name == 'Updated Specialty'

  Scenario: Update specialty returns 404 with invalid ID
    Given path 'specialties', 99999
    And request { id: 99999, name: 'Updated Specialty' }
    When method PUT
    Then status 404

  Scenario: Update specialty returns 404 with negative ID
    Given path 'specialties', -1
    And request { id: -1, name: 'Updated Specialty' }
    When method PUT
    Then status 404

  Scenario: Update specialty returns 404 with zero ID
    Given path 'specialties', 0
    And request { id: 0, name: 'Updated Specialty' }
    When method PUT
    Then status 404

  Scenario: Update specialty returns 404 with null ID
    Given path 'specialties', null
    And request { id: null, name: 'Updated Specialty' }
    When method PUT
    Then status 404

  Scenario: Update specialty returns 404 with string ID
    Given path 'specialties', 'invalid'
    And request { id: 'invalid', name: 'Updated Specialty' }
    When method PUT
    Then status 404

  Scenario: Update specialty returns 404 with decimal ID
    Given path 'specialties', 1.5
    And request { id: 1.5, name: 'Updated Specialty' }
    When method PUT
    Then status 404

  Scenario: Update specialty with empty name returns 400
    # First, create a specialty to update
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Try to update with empty name
    Given path 'specialties', specialtyId
    And request { id: specialtyId, name: '' }
    When method PUT
    Then status 400

  Scenario: Update specialty with null name returns 400
    # First, create a specialty to update
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Try to update with null name
    Given path 'specialties', specialtyId
    And request { id: specialtyId, name: null }
    When method PUT
    Then status 400

  Scenario: Update specialty without name field returns 400
    # First, create a specialty to update
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Try to update without name field
    Given path 'specialties', specialtyId
    And request { id: specialtyId }
    When method PUT
    Then status 400

  Scenario: Update specialty with very long name returns 400
    # First, create a specialty to update
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Try to update with very long name
    Given path 'specialties', specialtyId
    And request { id: specialtyId, name: 'A'.repeat(1000) }
    When method PUT
    Then status 400

  Scenario: Update specialty with whitespace only name returns 400
    # First, create a specialty to update
    Given path 'specialties'
    And request { name: 'Test Specialty' }
    When method POST
    Then status 201
    * def specialtyId = response.id
    
    # Try to update with whitespace only name
    Given path 'specialties', specialtyId
    And request { id: specialtyId, name: '   ' }
    When method PUT
    Then status 400

  Scenario: Update specialty with invalid authentication returns 401
    Given path 'specialties', 1
    And request { id: 1, name: 'Updated Specialty' }
    * header Authorization = 'Basic invalid_credentials'
    When method PUT
    Then status 401

  Scenario: Update specialty without authentication returns 401
    Given path 'specialties', 1
    And request { id: 1, name: 'Updated Specialty' }
    * header Authorization = null
    When method PUT
    Then status 401

  Scenario: Update specialty with malformed JSON returns 400
    Given path 'specialties', 1
    And request '{"id": 1, "name": "Updated Specialty", "invalid": }'
    When method PUT
    Then status 400

  Scenario: Update specialty with wrong content type returns 400
    Given path 'specialties', 1
    And request { id: 1, name: 'Updated Specialty' }
    * header Content-Type = 'text/plain'
    When method PUT
    Then status 400
