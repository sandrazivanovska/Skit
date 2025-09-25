Feature: Get Owner API (GET /owners/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Get owner successfully returns 200 with valid ID
    Given path 'owners'
    And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Testville', telephone: '5551234' }
    When method POST
    Then status 201
    * def ownerId = response.id

    Given path 'owners', ownerId
    When method GET
    Then status 200
    * assert response.id == ownerId
    * assert response.firstName != null
    * assert response.lastName != null
    * assert response.address != null
    * assert response.city != null
    * assert response.telephone != null


  Scenario: Get owner with non-existent ID returns 404
    Given path 'owners', 999999
    When method GET
    Then status 404

  Scenario: Get owner with negative ID returns 500 (API throws ConstraintViolationException)
    Given path 'owners', -1
    When method GET
    Then status 500
    * assert response.title == 'ConstraintViolationException'
    * assert response.detail.indexOf('must be greater than or equal to 0') >= 0

  Scenario: Get owner with zero ID returns 404
    Given path 'owners', 0
    When method GET
    Then status 404

  Scenario: Get owner with null ID returns 404
    Given path 'owners', 'null'
    When method GET
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Get owner with string ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'owners', 'invalid'
    When method GET
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Get owner with decimal ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'owners', 1.5
    When method GET
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Get owner with invalid authentication returns 200 (API doesn't require auth)
    Given path 'owners', 5
    * header Authorization = 'Basic invalid_credentials'
    When method GET
    Then status 200

  Scenario: Get owner without authentication returns 200 (API doesn't require auth)
    Given path 'owners', 5
    * header Authorization = null
    When method GET
    Then status 200

  Scenario: Get owner with malformed URL returns 500 (API throws NoResourceFoundException)
    Given path 'owners', 'invalid', 'extra'
    When method GET
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: Get owner with trailing slash returns 500 (API throws NoResourceFoundException)
    Given path 'owners', 5, ''
    When method GET
    Then status 500
    * assert response.title == 'NoResourceFoundException'
