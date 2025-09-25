Feature: Create Visit API (POST /visits)

Background:
  * url baseUrl
  * header Authorization = headers.Authorization
  * header Content-Type = headers['Content-Type']

Scenario: Create visit successfully returns 201 with valid data
  Given path 'visits'
  And request { date: '2024-01-15', description: 'Regular checkup', petId: 1 }
  When method POST
  Then status 201
  * match response ==
  """
  { id: '#number', date: '2024-01-15', description: 'Regular checkup', petId: 1 }
  """

Scenario: Missing required fields (no petId) -> 404 DataIntegrityViolationException
  Given path 'visits'
  And request { date: '2024-01-15', description: 'Regular checkup' }   # no petId
  When method POST
  Then status 404
  * match response contains { title: 'DataIntegrityViolationException' }

Scenario: Empty strings for fields (empty description) -> 400 MethodArgumentNotValidException
  Given path 'visits'
  And request { date: '2024-01-15', description: '', petId: 1 }
  When method POST
  Then status 400
  * match response.title == 'MethodArgumentNotValidException'

Scenario: Special characters in description are allowed -> 201
  Given path 'visits'
  And request { date: '2024-01-15', description: 'Visit-Description_123!@#', petId: 1 }
  When method POST
  Then status 201
  * match response contains { petId: 1 }

Scenario: Numeric description is allowed -> 201
  Given path 'visits'
  And request { date: '2024-01-15', description: '123', petId: 1 }
  When method POST
  Then status 201
  * match response contains { petId: 1 }

Scenario: Malformed JSON -> 500 HttpMessageNotReadableException
  Given path 'visits'
  And request '{"date":"2024-01-15","description":"Regular","invalid": }'
  When method POST
  Then status 500
  * match response.title == 'HttpMessageNotReadableException'

Scenario: Wrong content type still accepted -> 201
  Given path 'visits'
  And request { date: '2024-01-15', description: 'Regular checkup', petId: 1 }
  * header Content-Type = 'text/plain'
  When method POST
  Then status 201
  * match response contains { petId: 1 }