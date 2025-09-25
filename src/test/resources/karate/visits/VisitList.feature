Feature: List Visits API (GET /visits)

Background:
  * url baseUrl
  * header Authorization = headers.Authorization
  * header Content-Type = headers['Content-Type']

Scenario: List visits successfully returns 200 with non-empty list
  Given path 'visits'
  When method GET
  Then status 200
  * match response == '#[]'         
  * match each response contains { id: '#number', date: '#string', description: '#string', petId: '#number' }

Scenario: List visits with invalid authentication returns 200 (API doesn't require auth)
  Given path 'visits'
  * header Authorization = 'Basic invalid_credentials'
  When method GET
  Then status 200
  * match response == '#[]'

Scenario: List visits without authentication returns 200 (API doesn't require auth)
  Given path 'visits'
  * header Authorization = null
  When method GET
  Then status 200
  * match response == '#[]'

Scenario: List visits with malformed URL returns 500 (MethodArgumentTypeMismatchException)
  Given path 'visits', 'invalid'
  When method GET
  Then status 500
  * match response contains { title: 'MethodArgumentTypeMismatchException' }

Scenario: List visits with trailing slash returns 500 (NoResourceFoundException)
  Given path 'visits', ''
  When method GET
  Then status 500
  * match response contains { title: 'NoResourceFoundException' }
  * match response.detail contains 'No static resource'

Scenario: List visits with extra path segments returns 500 (NoResourceFoundException)
  Given path 'visits', 'extra', 'segments'
  When method GET
  Then status 500
  * match response contains { title: 'NoResourceFoundException' }
  * match response.detail contains 'No static resource'

Scenario: List visits with query parameters returns 200
  Given path 'visits'
  And param limit = 10
  When method GET
  Then status 200
  * match response == '#[]'
