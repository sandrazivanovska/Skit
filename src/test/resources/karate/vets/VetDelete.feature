Feature: Delete Vet API (DELETE /vets/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Delete vet by valid ID
    * def payload = { firstName: 'John', lastName: 'Doe', specialties: [] }
    Given path 'vets'
    And request payload
    When method POST
    Then status 201
    * def vetId = response.id

    Given path 'vets', vetId
    When method DELETE
    Then status 204


  Scenario: DELETE same vet twice (idempotency)
    * def payload = { firstName: 'John', lastName: 'Doe', specialties: [] }
    Given path 'vets'
    And request payload
    When method POST
    Then status 201
    * def vetId = response.id

    Given path 'vets', vetId
    When method DELETE
    Then status 204

    Given path 'vets', vetId
    When method DELETE
    Then status 404

  Scenario: Delete vet by invalid ID (null)
    * def vetId = null
    Given path 'vets', vetId
    When method DELETE
    Then status 500

  Scenario: Delete vet with empty ID
    * def vetId = ''
    Given path 'vets', vetId
    When method DELETE
    Then status 500

  Scenario: Delete vet by negative ID
    * def vetId = -2
    Given path 'vets', vetId
    When method DELETE
    Then status 500

  Scenario: Delete vet by string ID
    Given path 'vets', 'abcd'
    When method DELETE
    Then status 500

  Scenario: Delete vet with very large ID
    * def vetId = 9223372036854775807
    Given path 'vets', vetId
    When method DELETE
    Then status 500
