Feature: Owner Pet Management API - Current Buggy Behavior Tests

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  # These tests expect the current buggy behavior where pet creation fails
  # due to DataIntegrityViolationException caused by pet.getType().setName(null)
  
  Scenario: Pet creation currently fails with DataIntegrityViolationException
    # First, create an owner
    Given path 'owners'
    And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    # Add a pet to the owner - this currently fails due to bug
    Given path 'owners', ownerId, 'pets'
    And request { name: 'Test Pet', birthDate: '2020-01-01', type: { id: 1, name: 'cat' } }
    When method POST
    # Expect 404 with DataIntegrityViolationException due to current bug
    Then status 404
    * assert response.title == 'DataIntegrityViolationException'
    * assert response.detail.indexOf('NULL not allowed for column "TYPE_ID"') >= 0

  Scenario: Pet creation with different pet type also fails
    # First, create an owner
    Given path 'owners'
    And request { firstName: 'Jane', lastName: 'Smith', address: '456 Oak Ave', city: 'Somewhere', telephone: '5555678' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    # Add a pet with dog type - this also fails due to same bug
    Given path 'owners', ownerId, 'pets'
    And request { name: 'Dog Pet', birthDate: '2020-02-02', type: { id: 2, name: 'dog' } }
    When method POST
    # Expect 404 with DataIntegrityViolationException due to current bug
    Then status 404
    * assert response.title == 'DataIntegrityViolationException'
    * assert response.detail.indexOf('NULL not allowed for column "TYPE_ID"') >= 0

  Scenario: Pet creation with bird type also fails
    # First, create an owner
    Given path 'owners'
    And request { firstName: 'Bob', lastName: 'Johnson', address: '789 Pine St', city: 'Elsewhere', telephone: '5559012' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    # Add a pet with bird type - this also fails due to same bug
    Given path 'owners', ownerId, 'pets'
    And request { name: 'Bird Pet', birthDate: '2020-03-03', type: { id: 3, name: 'bird' } }
    When method POST
    # Expect 404 with DataIntegrityViolationException due to current bug
    Then status 404
    * assert response.title == 'DataIntegrityViolationException'
    * assert response.detail.indexOf('NULL not allowed for column "TYPE_ID"') >= 0
