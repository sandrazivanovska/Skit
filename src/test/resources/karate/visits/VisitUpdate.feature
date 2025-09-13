Feature: Update Visit API (PUT /visits/{id})

Background:
  * url baseUrl
  * header Authorization = headers.Authorization
  * header Content-Type = headers['Content-Type']

  # Create an owner we can use
  Given path 'owners'
  And request { firstName: 'Upd', lastName: 'User', address: '1 Test St', city: 'Testville', telephone: '5550000' }
  When method POST
  Then status 201
  * def ownerId = response.id

  # Create a pet for that owner (type must be provided)
  Given path 'owners', ownerId, 'pets'
  And request { name: 'UpdPet', birthDate: '2020-01-01', type: { id: 1, name: 'cat' } }
  When method POST
  Then status 201
  * def petId = response.id

  # Create a visit we will update
  Given path 'visits'
  And request { date: '2024-01-15', description: 'Initial checkup', petId: #(petId) }
  When method POST
  Then status 201
  * def visitId = response.id

Scenario: Update visit successfully returns 204 with valid data
  Given path 'visits', visitId
  And request { id: #(visitId), date: '2024-02-15', description: 'Updated checkup', petId: #(petId) }
  When method PUT
  Then status 204

  # Verify read-back
  Given path 'visits', visitId
  When method GET
  Then status 200
  * match response contains { id: #(visitId), description: 'Updated checkup', petId: #(petId) }

Scenario: Update visit with negative ID (path and body) -> 400 (validation)
  Given path 'visits', -1
  And request { id: -1, date: '2024-01-15', description: 'Checkup', petId: #(petId) }
  When method PUT
  Then status 400
  * match response contains { title: 'MethodArgumentNotValidException' }

Scenario: Update visit without ID in path -> 500 (method not supported on collection)
  Given path 'visits'
  And request { id: #(visitId), date: '2024-01-15', description: 'Checkup', petId: #(petId) }
  When method PUT
  Then status 500
  * match response contains { title: 'HttpRequestMethodNotSupportedException' }

Scenario: Update visit with string ID -> 500 (type mismatch)
  Given path 'visits', 'invalid'
  And request { id: 1, date: '2024-01-15', description: 'Checkup', petId: #(petId) }
  When method PUT
  Then status 500
  * match response contains { title: 'MethodArgumentTypeMismatchException' }

Scenario: Update visit with decimal ID -> 500 (type mismatch)
  Given path 'visits', 1.5
  And request { id: 1, date: '2024-01-15', description: 'Checkup', petId: #(petId) }
  When method PUT
  Then status 500
  * match response contains { title: 'MethodArgumentTypeMismatchException' }

# Missing required fields triggers DB NOT NULL / FK -> 404 DataIntegrityViolationException
Scenario: Update visit with missing required fields -> 404
  Given path 'visits', visitId
  And request { id: #(visitId), description: 'Only description' }   # missing date & petId
  When method PUT
  Then status 404
  * match response contains { title: 'DataIntegrityViolationException' }

Scenario: Update visit with null required fields -> 400
  Given path 'visits', visitId
  And request { id: #(visitId), date: null, description: null, petId: null }
  When method PUT
  Then status 400
  * match response contains { title: 'MethodArgumentNotValidException' }

# API validates description size 1..255 -> empty is 400
Scenario: Update visit with empty description -> 400
  Given path 'visits', visitId
  And request { id: #(visitId), date: '2024-03-01', description: '', petId: #(petId) }
  When method PUT
  Then status 400
  * match response contains { title: 'MethodArgumentNotValidException' }

# >255 chars -> 400
Scenario: Update visit with very long description -> 400
  * def longText = 'x'.repeat(1000)
  Given path 'visits', visitId
  And request { id: #(visitId), date: '2024-03-02', description: '#(longText)', petId: #(petId) }
  When method PUT
  Then status 400
  * match response contains { title: 'MethodArgumentNotValidException' }

Scenario: Update visit with non-existent petId -> 404 (FK violation surfaces as 404)
  Given path 'visits', visitId
  And request { id: #(visitId), date: '2024-04-01', description: 'Bad pet', petId: 999999 }
  When method PUT
  Then status 404

Scenario: Update visit with malformed JSON -> 500 (read error)
  Given path 'visits', visitId
  And request '{"id": 10, "date": "2024-01-15", "description": "Checkup", "invalid": }'
  When method PUT
  Then status 500
  * match response contains { title: 'HttpMessageNotReadableException' }

# For PUT with wrong content-type, the endpoint still processes -> 204
Scenario: Update visit with wrong content-type -> 204
  Given path 'visits', visitId
  And request { id: #(visitId), date: '2024-06-01', description: 'Wrong CT', petId: #(petId) }
  * header Content-Type = 'text/plain'
  When method PUT
  Then status 204

# Auth is ignored on this API -> still 204
Scenario: Update visit with invalid auth -> 204
  Given path 'visits', visitId
  * header Authorization = 'Basic invalid_credentials'
  And request { id: #(visitId), date: '2024-07-01', description: 'Auth ignored', petId: #(petId) }
  When method PUT
  Then status 204

Scenario: Update visit without auth -> 204
  Given path 'visits', visitId
  * header Authorization = null
  And request { id: #(visitId), date: '2024-07-15', description: 'No auth', petId: #(petId) }
  When method PUT
  Then status 204
