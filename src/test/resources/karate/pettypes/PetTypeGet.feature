Feature: Get Pet Type API (GET /pettypes/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Get pet type successfully returns 200 with valid ID
    Given path 'pettypes', 2
    When method GET
    Then status 200
    * assert response.id == 2
    * assert response.name != null

  Scenario: Get pet type with non-existent ID returns 404
    Given path 'pettypes', 999999
    When method GET
    Then status 404

  Scenario: Get pet type with negative ID returns 500 (API throws ConstraintViolationException)
    Given path 'pettypes', -1
    When method GET
    Then status 500
    * assert response.title == 'ConstraintViolationException'
    * assert response.detail.indexOf('must be greater than or equal to 0') >= 0

  Scenario: Get pet type with zero ID returns 404
    Given path 'pettypes', 0
    When method GET
    Then status 404

  Scenario: Get pet type with null ID returns 404
    Given path 'pettypes', null
    When method GET
    Then status 404

  Scenario: Get pet type with string ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'pettypes', 'invalid'
    When method GET
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Get pet type with decimal ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'pettypes', 1.5
    When method GET
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Get pet type with invalid authentication returns 200 (API doesn't require auth)
    Given path 'pettypes', 2
    * header Authorization = 'Basic invalid_credentials'
    When method GET
    Then status 200

  Scenario: Get pet type without authentication returns 200 (API doesn't require auth)
    Given path 'pettypes', 2
    * header Authorization = null
    When method GET
    Then status 200

  Scenario: Get pet type with malformed URL returns 500 (API throws NoResourceFoundException)
    Given path 'pettypes', 'invalid', 'extra'
    When method GET
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: Get pet type with trailing slash returns 500 (API throws NoResourceFoundException)
    Given path 'pettypes', 2, ''
    When method GET
    Then status 500
    * assert response.title == 'NoResourceFoundException'
