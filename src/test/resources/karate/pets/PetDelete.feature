# karate/pets/PetDelete.feature
Feature: Delete Pet API (DELETE /pets/{id})

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

  Scenario: Delete pet by valid ID
    * def newPet =
    """
    {
      "name": "Rex",
      "birthDate": "2020-01-01",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'owners', ownerId, 'pets'
    And request newPet
    When method POST
    Then status 201
    * def petId = response.id

    Given path 'pets', petId
    When method DELETE
    Then status 204

  Scenario: DELETE same pet twice (idempotency)
    * def newPet =
    """
    {
      "name": "Bella",
      "birthDate": "2019-05-20",
      "type": { "id": #(petType.id), "name": "#(petType.name)" }
    }
    """
    Given path 'owners', ownerId, 'pets'
    And request newPet
    When method POST
    Then status 201
    * def petId = response.id

    Given path 'pets', petId
    When method DELETE
    Then status 204

    Given path 'pets', petId
    When method DELETE
    Then status 404

  Scenario: Delete pet by invalid ID (null)
    * def petId = null
    Given path 'pets', petId
    When method DELETE
    Then status 500

  Scenario: Delete pet with empty ID
    * def petId = ''
    Given path 'pets', petId
    When method DELETE
    Then status 500

  Scenario: Delete pet by negative ID
    * def petId = -2
    Given path 'pets', petId
    When method DELETE
    Then status 500

  Scenario: Delete pet by string ID
    Given path 'pets', 'abcd'
    When method DELETE
    Then status 500

  Scenario: Delete pet with very large ID
    * def petId = 9223372036854775807
    Given path 'pets', petId
    When method DELETE
    Then status 500
