Feature: Delete Pet Type API (DELETE /pettypes/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Delete pet type successfully returns 204 with valid ID
    Given path 'pettypes', 13
    When method DELETE
    Then status 204

  Scenario: Delete pet type with negative ID returns 500 (API throws ConstraintViolationException)
    Given path 'pettypes', -1
    When method DELETE
    Then status 500
    * assert response.title == 'ConstraintViolationException'
    * assert response.detail.indexOf('must be greater than or equal to 0') >= 0

  Scenario: Delete pet type without ID in path returns 500 (API throws HttpRequestMethodNotSupportedException)
    Given path 'pettypes'
    When method DELETE
    Then status 500
    * assert response.title == 'HttpRequestMethodNotSupportedException'

  Scenario: Delete pet type with string ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'pettypes', 'invalid'
    When method DELETE
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Delete pet type with decimal ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'pettypes', 1.5
    When method DELETE
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Delete pet type with non-existent ID returns 404
    Given path 'pettypes', 999999
    When method DELETE
    Then status 404

  Scenario: Delete pet type with invalid authentication returns 204 (API doesn't require auth)
    Given path 'pettypes', 14
    * header Authorization = 'Basic invalid_credentials'
    When method DELETE
    Then status 204

  Scenario: Delete pet type without authentication returns 204 (API doesn't require auth)
    Given path 'pettypes', 14
    * header Authorization = null
    When method DELETE
    Then status 204

  Scenario: Delete pet type with malformed URL returns 500 (API throws NoResourceFoundException)
    Given path 'pettypes', 'invalid', 'extra'
    When method DELETE
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: Delete pet type with trailing slash returns 500 (API throws NoResourceFoundException)
    Given path 'pettypes', 15, ''
    When method DELETE
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: Delete already deleted pet type returns 404
    Given path 'pettypes', 16
    When method DELETE
    Then status 404
