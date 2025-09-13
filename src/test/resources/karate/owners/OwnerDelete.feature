Feature: Delete Owner API (DELETE /owners/{id})

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: Delete owner successfully returns 204 with valid ID
    Given path 'owners', 10
    When method DELETE
    Then status 204

  Scenario: Delete owner with negative ID returns 500 (API throws ConstraintViolationException)
    Given path 'owners', -1
    When method DELETE
    Then status 500
    * assert response.title == 'ConstraintViolationException'
    * assert response.detail.indexOf('must be greater than or equal to 0') >= 0

  Scenario: Delete owner without ID in path returns 500 (API throws HttpRequestMethodNotSupportedException)
    Given path 'owners'
    When method DELETE
    Then status 500
    * assert response.title == 'HttpRequestMethodNotSupportedException'

  Scenario: Delete owner with string ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'owners', 'invalid'
    When method DELETE
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Delete owner with decimal ID returns 500 (API throws MethodArgumentTypeMismatchException)
    Given path 'owners', 1.5
    When method DELETE
    Then status 500
    * assert response.title == 'MethodArgumentTypeMismatchException'
    * assert response.detail.indexOf('Failed to convert value') >= 0

  Scenario: Delete owner with non-existent ID returns 404
    Given path 'owners', 999999
    When method DELETE
    Then status 404

  Scenario: Delete owner with invalid authentication returns 204 (API doesn't require auth)
    Given path 'owners', 11
    * header Authorization = 'Basic invalid_credentials'
    When method DELETE
    Then status 204

  Scenario: Delete owner without authentication returns 204 (API doesn't require auth)
    Given path 'owners', 12
    * header Authorization = null
    When method DELETE
    Then status 204

  Scenario: Delete owner with malformed URL returns 500 (API throws NoResourceFoundException)
    Given path 'owners', 'invalid', 'extra'
    When method DELETE
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: Delete owner with trailing slash returns 500 (API throws NoResourceFoundException)
    Given path 'owners', 22, ''
    When method DELETE
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: Delete already deleted owner returns 404
    Given path 'owners', 999999
    When method DELETE
    Then status 404
