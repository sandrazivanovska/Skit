Feature: Owner Pet Management API

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Get owner's pet successfully returns 200 with valid data
    Given path 'owners'
    And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets'
    And request { name: 'Test Pet', birthDate: '2020-01-01', type: { id: 1, name: 'cat' } }
    When method POST
    Then status 201
    * def petId = response.id
    
    Given path 'owners', ownerId, 'pets', petId
    When method GET
    Then status 200
    * assert response.id == petId
    * assert response.name == 'Test Pet'

  Scenario: Get owner's pet returns 404 with invalid owner ID
    Given path 'owners', 99999, 'pets', 1
    When method GET
    Then status 404

  Scenario: Get owner's pet returns 404 with invalid pet ID
    Given path 'owners'
    And request { firstName: 'Jane', lastName: 'Smith', address: '456 Oak Ave', city: 'Somewhere', telephone: '5555678' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets', 99999
    When method GET
    Then status 404

  Scenario: Add pet to owner successfully returns 201 with valid data
    Given path 'owners'
    And request { firstName: 'Bob', lastName: 'Johnson', address: '789 Pine St', city: 'Elsewhere', telephone: '5559012' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets'
    And request { name: 'New Pet', birthDate: '2020-02-02', type: { id: 2, name: 'dog' } }
    When method POST
    Then status 201
    * assert response.id != null
    * assert response.name == 'New Pet'
    * assert response.ownerId == ownerId

  Scenario: Add pet to owner with missing required fields returns 400
    Given path 'owners'
    And request { firstName: 'Alice', lastName: 'Brown', address: '321 Elm St', city: 'Nowhere', telephone: '5553456' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets'
    And request { birthDate: '2020-03-03', type: { id: 3, name: 'bird' } }
    When method POST
    Then status 400

  Scenario: Update owner's pet successfully returns 204 with valid data
    Given path 'owners'
    And request { firstName: 'Charlie', lastName: 'Wilson', address: '654 Maple St', city: 'Anywhere', telephone: '5557890' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets'
    And request { name: 'Original Pet', birthDate: '2020-04-04', type: { id: 4, name: 'snake' } }
    When method POST
    Then status 201
    * def petId = response.id
    
    Given path 'owners', ownerId, 'pets', petId
    And request { name: 'Updated Pet', birthDate: '2020-05-05', type: { id: 5, name: 'bird' } }
    When method PUT
    Then status 204

  Scenario: Update owner's pet returns 404 with invalid owner ID (API validates owner existence)
    Given path 'owners', 99999, 'pets', 1
    And request { name: 'Updated Pet', birthDate: '2020-05-05', type: { id: 1, name: 'cat' } }
    When method PUT
    Then status 404

  Scenario: Update owner's pet returns 404 with invalid pet ID
    Given path 'owners'
    And request { firstName: 'David', lastName: 'Miller', address: '987 Cedar St', city: 'Somewhere', telephone: '5551111' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets', 99999
    And request { name: 'Updated Pet', birthDate: '2020-05-05', type: { id: 1, name: 'cat' } }
    When method PUT
    Then status 404

  Scenario: Add visit to owner's pet successfully returns 201 with valid data
    Given path 'owners'
    And request { firstName: 'Eva', lastName: 'Davis', address: '147 Birch St', city: 'Everywhere', telephone: '5552222' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets'
    And request { name: 'Visit Pet', birthDate: '2020-06-06', type: { id: 6, name: 'hamster' } }
    When method POST
    Then status 201
    * def petId = response.id
    
    Given path 'owners', ownerId, 'pets', petId, 'visits'
    And request { date: '2024-01-15', description: 'Regular checkup' }
    When method POST
    Then status 201
    * assert response.id != null
    * assert response.date == '2024-01-15'
    * assert response.description == 'Regular checkup'
    * assert response.petId == petId

  Scenario: Add visit to owner's pet returns 404 with invalid owner ID (API validates referential integrity)
    Given path 'owners', 99999, 'pets', 1, 'visits'
    And request { date: '2024-01-15', description: 'Regular checkup' }
    When method POST
    Then status 404
    * assert response.title == 'DataIntegrityViolationException'
    * assert response.detail.indexOf('Referential integrity constraint violation') >= 0

  Scenario: Add visit to owner's pet returns 404 with invalid pet ID
    Given path 'owners'
    And request { firstName: 'Frank', lastName: 'Garcia', address: '258 Spruce St', city: 'Nowhere', telephone: '5553333' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets', 99999, 'visits'
    And request { date: '2024-01-15', description: 'Regular checkup' }
    When method POST
    Then status 404

  Scenario: Add visit to owner's pet with missing required fields returns 400
    Given path 'owners'
    And request { firstName: 'Grace', lastName: 'Martinez', address: '369 Oak St', city: 'Anywhere', telephone: '5554444' }
    When method POST
    Then status 201
    * def ownerId = response.id
    
    Given path 'owners', ownerId, 'pets'
    And request { name: 'Visit Pet 2', birthDate: '2020-07-07', type: { id: 1, name: 'cat' } }
    When method POST
    Then status 201
    * def petId = response.id
    
    Given path 'owners', ownerId, 'pets', petId, 'visits'
    And request { description: 'Regular checkup' }
    When method POST
    Then status 404
    * assert response.title == 'DataIntegrityViolationException'
    * assert response.detail.indexOf('NULL not allowed for column') >= 0
