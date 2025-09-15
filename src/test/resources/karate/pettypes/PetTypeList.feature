Feature: List Pet Types API (GET /pettypes)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: List pet types successfully returns 200 when pet types exist
    Given path 'pettypes'
    When method GET
    Then status 200
    * assert response.length > 0
    * assert response[0].id != null
    * assert response[0].name != null

  Scenario: List pet types with invalid authentication returns 200 (API doesn't require auth)
    Given path 'pettypes'
    * header Authorization = 'Basic invalid_credentials'
    When method GET
    Then status 200
    * assert response.length > 0

  Scenario: List pet types without authentication returns 200 (API doesn't require auth)
    Given path 'pettypes'
    * header Authorization = null
    When method GET
    Then status 200
    * assert response.length > 0

  Scenario: List pet types with malformed URL returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'pettypes', 'invalid'
    When method GET
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'

  Scenario: List pet types with trailing slash returns 500 (API throws NoResourceFoundException)
    Given path 'pettypes', ''
    When method GET
    Then status 500
    * assert response.title == 'NoResourceFoundException'
