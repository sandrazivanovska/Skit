Feature: Delete Visit API (DELETE /visits/{id})

Background:
  * url baseUrl
  * header Authorization = headers.Authorization
  * header Content-Type = headers['Content-Type']

Scenario: Delete visit successfully returns 204 then 404 when deleted again
  Given path 'visits'
  And request { date: '2024-03-01', description: 'to delete', petId: 1 }
  When method POST
  Then status 201
  * def visitId = response.id

  Given path 'visits', visitId
  When method DELETE
  Then status 204

  Given path 'visits', visitId
  When method DELETE
  Then status 404

Scenario: Delete visit with zero ID returns 404 (id=0 doesn't exist)
  Given path 'visits', 0
  When method DELETE
  Then status 404

Scenario: Delete visit without ID in path -> 500 HttpRequestMethodNotSupportedException
  Given path 'visits'
  When method DELETE
  Then status 500
  * match response contains { title: 'HttpRequestMethodNotSupportedException' }

Scenario: Delete visit with negative ID -> 500 ConstraintViolationException
  Given path 'visits', -1
  When method DELETE
  Then status 500
  * match response contains { title: 'ConstraintViolationException' }

Scenario: Delete visit with string ID -> 500 MethodArgumentTypeMismatchException
  Given path 'visits', 'invalid'
  When method DELETE
  Then status 500
  * match response contains { title: 'MethodArgumentTypeMismatchException' }

Scenario: Delete visit with decimal ID -> 500 MethodArgumentTypeMismatchException
  Given path 'visits', 1.5
  When method DELETE
  Then status 500
  * match response contains { title: 'MethodArgumentTypeMismatchException' }

Scenario: Delete visit with non-existent ID returns 404
  Given path 'visits', 999999
  When method DELETE
  Then status 404

Scenario: Delete visit with invalid authentication still returns 204 (endpoint is open)
  Given path 'visits'
  And request { date: '2024-03-02', description: 'auth test', petId: 1 }
  When method POST
  Then status 201
  * def id = response.id

  Given path 'visits', id
  * header Authorization = 'Basic invalid_credentials'
  When method DELETE
  Then status 204

Scenario: Delete visit without authentication returns 204
  Given path 'visits'
  And request { date: '2024-03-03', description: 'no auth test', petId: 1 }
  When method POST
  Then status 201
  * def id = response.id

  Given path 'visits', id
  * header Authorization = null
  When method DELETE
  Then status 204

Scenario: Delete visit with malformed URL -> 500 NoResourceFoundException
  Given path 'visits', 'invalid', 'extra'
  When method DELETE
  Then status 500
  * match response contains { title: 'NoResourceFoundException' }

Scenario: Delete visit with trailing slash -> 500 NoResourceFoundException
  Given path 'visits', 123, ''
  When method DELETE
  Then status 500
  * match response contains { title: 'NoResourceFoundException' }
