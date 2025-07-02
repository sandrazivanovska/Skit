Feature: Update Vet (PUT /vets/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Update vet with valid data
    * def newVet = { "firstName": "John", "lastName": "Doe", "specialties": [] }

    Given path 'vets'
    And request newVet
    When method POST
    Then status 201
    * def vetId = response.id

    * def updateVet = { "firstName": "Jonathan", "lastName": "Doe-Smith","specialties": [ { "name": "radiology" } ] }

    Given path 'vets', vetId
    And request updateVet
    When method PUT
    Then status 204

  Scenario: Update non-existent vet returns 404
    * def bogusId = 999999
    * def payload = { "firstName": "No", "lastName": "One", "specialties": [] }

    Given path 'vets', bogusId
    And request payload
    When method PUT
    Then status 404

  Scenario: Update vet with invalid payload (empty names) returns 400
    # create a vet to update
    * def newVet2 = { "firstName": "Alice", "lastName": "Smith", "specialties": [] }

    Given path 'vets'
    And request newVet2
    When method POST
    Then status 201
    * def vetId2 = response.id

    # attempt invalid update
    * def badUpdate = { firstName: '', lastName: '', specialties: [] }
    Given path 'vets', vetId2
    And request badUpdate
    When method PUT
    Then status 400

  Scenario: Update vet with null ID returns 400
    * def nullId = null
    * def payload = { "firstName": "Null", "lastName": "ID", "specialties": [] }

    Given path 'vets', nullId
    And request payload
    When method PUT
    Then status 400

  Scenario: Update vet with empty ID returns 400
    * def emptyId = ''
    Given path 'vets', emptyId
    And request { firstName: 'E', lastName: 'M', specialties: [] }
    When method PUT
    Then status 400

  Scenario: Update vet with string ID returns 400
    Given path 'vets', 'abcd'
    And request { firstName: 'X', lastName: 'Y', specialties: [] }
    When method PUT
    Then status 400

  Scenario: Update vet with very large ID returns 404
    * def largeId = 9223372036854775807
    And request { firstName: 'Big', lastName: 'Number', specialties: [] }
    Given path 'vets', largeId
    When method PUT
    Then status 404
