# karate/pets/PetGet.feature
Feature: Get Pet by ID (GET /pets/{id})

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

  Scenario: Get pet by valid ID
    * def newPet =
    """
    {
      "name": "Milo",
      "birthDate": "2021-02-02",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'owners', ownerId, 'pets'
    And request newPet
    When method POST
    Then status 201
    * def petId = response.id

    Given path 'pets', petId
    When method GET
    Then status 200
    And match response.id == petId

  Scenario: Get non-existing pet returns 404
    Given path 'pets', 999999
    When method GET
    Then status 404

  Scenario: Get pet with empty ID
    Given path 'pets', ''
    When method GET
    Then status 500

  Scenario: Get pet with negative ID
    Given path 'pets', -5
    When method GET
    Then status 500

  Scenario: Get pet with string ID
    Given path 'pets', 'abcd'
    When method GET
    Then status 500

  Scenario: Get pet with special characters ID
    Given path 'pets', '@$!'
    When method GET
    Then status 500

  Scenario: Get pet with very large ID
    Given path 'pets', 9223372036854775807
    When method GET
    Then status 500
