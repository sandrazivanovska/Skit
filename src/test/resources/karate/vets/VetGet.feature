Feature: Get Vet by ID (GET /vets/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Get vet by valid ID
    # create a new vet first
    * def newVet ={ firstName: 'John', lastName: 'Doe', specialties: [] }
    Given path 'vets'
    And request newVet
    When method POST
    Then status 201
    * def vetId = response.id

    Given path 'vets', vetId
    When method GET
    Then status 200
    And match response.id == vetId

  Scenario: Get non-existing vet returns 404
    Given path 'vets', 999999
    When method GET
    Then status 500

  Scenario: Get vet with null ID
    Given path 'vets', null
    When method GET
    Then status 500

  Scenario: Get vet with empty ID
    Given path 'vets', ''
    When method GET
    Then status 500

  Scenario: Get vet with negative ID
    Given path 'vets', -5
    When method GET
    Then status 500

  Scenario: Get vet with string ID
    Given path 'vets', 'abcd'
    When method GET
    Then status 500

  Scenario: Get vet with special characters ID
    Given path 'vets', '@$!'
    When method GET
    Then status 500

  Scenario: Get vet with very large ID
    Given path 'vets', 9223372036854775807
    When method GET
    Then status 500
