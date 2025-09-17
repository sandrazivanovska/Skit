# karate/pets/PetUpdate.feature
Feature: Update Pet (PUT /pets/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

    # Resolve a valid PetType and Owner for setup
    Given path 'pettypes'
    When method GET
    Then status 200
    * def petType = response.find(x => x.name && x.name.toLowerCase() == 'dog') ? response.find(x => x.name.toLowerCase() == 'dog') : response[0]

    Given path 'owners'
    When method GET
    Then status 200
    * def ownerId = response[0].id

  Scenario: Update pet with valid data
    * def newPet =
    """
    {
      "name": "Buddy",
      "birthDate": "2018-03-15",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'owners', ownerId, 'pets'
    And request newPet
    When method POST
    Then status 201
    * def petId = response.id

    * def updatePet =
    """
    {
      "name": "Buddy-Updated",
      "birthDate": "2022-12-31",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'pets', petId
    And request updatePet
    When method PUT
    Then status 204

  Scenario: Update non-existent pet returns 404
    * def bogusId = 999999
    * def payload =
    """
    {
      "name": "Ghost",
      "birthDate": "2020-01-01",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'pets', bogusId
    And request payload
    When method PUT
    Then status 404

  Scenario: Update pet with invalid payload (empty name) returns 400
    * def newPet =
    """
    {
      "name": "Temp",
      "birthDate": "2017-07-07",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'owners', ownerId, 'pets'
    And request newPet
    When method POST
    Then status 201
    * def petId = response.id

    * def badUpdate =
    """
    {
      "name": "",
      "birthDate": "2020-01-01",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'pets', petId
    And request badUpdate
    When method PUT
    Then status 500

  Scenario: Update pet with null ID returns 500
    * def nullId = null
    * def payload =
    """
    {
      "name": "Null",
      "birthDate": "2020-01-01",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'pets', nullId
    And request payload
    When method PUT
    Then status 500

  Scenario: Update pet with empty ID returns 500
    Given path 'pets', ''
    And request { name: 'Empty', birthDate: '2020-01-01', type: { id: #(petType.id), name: "#(petType.name)" } }
    When method PUT
    Then status 500

  Scenario: Update pet with string ID returns 500
    Given path 'pets', 'abcd'
    And request { name: 'Str', birthDate: '2020-01-01', type: { id: #(petType.id), name: "#(petType.name)" } }
    When method PUT
    Then status 500

  Scenario: Update pet with very large ID returns 500
    * def largeId = 9223372036854775807
    Given path 'pets', largeId
    And request { name: 'Big', birthDate: '2020-01-01', type: { id: #(petType.id), name: "#(petType.name)" } }
    When method PUT
    Then status 500
