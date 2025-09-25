Feature: Get Visit API (GET /visits/{id})

Background:
  * url baseUrl
  * header Authorization = headers.Authorization
  * header Content-Type = headers['Content-Type']

Scenario: Get visit successfully returns 200 with valid ID
  Given path 'visits', 1
  When method GET
  Then status 200
  * match response ==
  """
  { id: 1, date: '#string', description: '#string', petId: '#number' }
  """

Scenario: Get visit with non-existent ID returns 404
  Given path 'visits', 999999
  When method GET
  Then status 404

Scenario: Get visit with negative ID returns 500 (ConstraintViolationException)
  Given path 'visits', -1
  When method GET
  Then status 500
  * match response contains { title: 'ConstraintViolationException' }

Scenario: Get visit with zero ID returns 404
  Given path 'visits', 0
  When method GET
  Then status 404

Scenario: Get visit with string ID returns 500 (MethodArgumentTypeMismatchException)
  Given path 'visits', 'invalid'
  When method GET
  Then status 500
  * match response contains { title: 'MethodArgumentTypeMismatchException' }

Scenario: Get visit with decimal ID returns 500 (MethodArgumentTypeMismatchException)
  Given path 'visits', 1.5
  When method GET
  Then status 500
  * match response contains { title: 'MethodArgumentTypeMismatchException' }

Scenario: Get visit with invalid authentication still returns 200
  Given path 'visits', 1
  * header Authorization = 'Basic invalid_credentials'
  When method GET
  Then status 200

Scenario: Get visit without authentication still returns 200
  Given path 'visits', 1
  * header Authorization = null
  When method GET
  Then status 200

Scenario: Get visit with malformed URL returns 500 (NoResourceFoundException)
  Given path 'visits', 'invalid', 'extra'
  When method GET
  Then status 500
  * match response contains { title: 'NoResourceFoundException' }

Scenario: Get visit with trailing slash returns 500 (NoResourceFoundException)
  Given path 'visits', 1, ''
  When method GET
  Then status 500
  * match response contains { title: 'NoResourceFoundException' }
