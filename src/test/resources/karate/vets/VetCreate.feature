Feature: Add a new vet (POST /vets)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Add a new vet with valid JSON
    * def body =
      """
      {
        "firstName": "Sam",
        "lastName": "Winchester",
        "specialties": [
          { "name": "radiology" },
          { "name": "surgery" }
        ]
      }
      """
    Given path 'vets'
    And request body
    When method POST
    Then status 201
    And match response.firstName == body.firstName
    * def vetId = response.id

  Scenario: Add vet with unknown/invalid field
    * def body = { "invalidField": "oops" }
    Given path 'vets'
    And request body
    When method POST
    Then status 400

  Scenario: POST with invalid Content-Type
    * header Content-Type = 'text/plain'
    Given path 'vets'
    And request 'firstName=John&lastName=Doe'
    When method POST
    Then status 500

  Scenario: Add vet with empty payload
    Given path 'vets'
    And request {}
    When method POST
    Then status 400

  Scenario: Add vet with missing firstName
    * def body = { "lastName": "Doe", "specialties": [] }
    Given path 'vets'
    And request body
    When method POST
    Then status 400

  Scenario: Add vet with missing lastName
    * def body = { "firstName": "John", "specialties": [] }
    Given path 'vets'
    And request body
    When method POST
    Then status 400

  Scenario: Add vet with null specialties
    * def body =
      """
      {
        "firstName": "John",
        "lastName": "Doe",
        "specialties": null
      }
      """
    Given path 'vets'
    And request body
    When method POST
    Then status 400

  Scenario: Add vet with empty specialties list
    * def body =
      """
      {
        "firstName": "John",
        "lastName": "Doe",
        "specialties": []
      }
      """
    Given path 'vets'
    And request body
    When method POST
    Then status 201

  Scenario: Add vet with invalid nested field in specialties
    * def body =
      """
      {
        "firstName": "John",
        "lastName": "Doe",
        "specialties": [
          { "unknown": "x" }
        ]
      }
      """
    Given path 'vets'
    And request body
    When method POST
    Then status 400
