Feature: Update Owner API (PUT /owners/{id})

Background:
  * url baseUrl
  * header Authorization = headers.Authorization
  * header Content-Type = headers['Content-Type']

Scenario: Update owner successfully returns 204 with valid data
  Given path 'owners'
  And request { firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: 'Updated John', lastName: 'Updated Doe', address: '456 Updated St', city: 'Updated City', telephone: '5559999' }
  When method PUT
  Then status 204

Scenario: Update owner with negative ID returns 500 (API throws ConstraintViolationException)
  Given path 'owners', -1
  And request { id: -1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  When method PUT
  Then status 500
  * assert response.title == 'ConstraintViolationException'
  * assert response.detail.indexOf('must be greater than or equal to 0') >= 0

Scenario: Update owner without ID in path returns 500 (API throws HttpRequestMethodNotSupportedException)
  Given path 'owners'
  And request { id: 1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  When method PUT
  Then status 500
  * assert response.title == 'HttpRequestMethodNotSupportedException'

Scenario: Update owner with string ID returns 500 (API throws MethodArgumentTypeMismatchException)
  Given path 'owners', 'invalid'
  And request { id: 1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  When method PUT
  Then status 500
  * assert response.title == 'MethodArgumentTypeMismatchException'
  * assert response.detail.indexOf('Failed to convert value') >= 0

Scenario: Update owner with decimal ID returns 500 (API throws MethodArgumentTypeMismatchException)
  Given path 'owners', 1.5
  And request { id: 1, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  When method PUT
  Then status 500
  * assert response.title == 'MethodArgumentTypeMismatchException'
  * assert response.detail.indexOf('Failed to convert value') >= 0

Scenario: Update owner with missing required fields returns 400 (API validates required fields)
  Given path 'owners'
  And request { firstName: 'Test', lastName: 'Owner', address: '123 Test St', city: 'Test City', telephone: '1112223333' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: 'John' }
  When method PUT
  Then status 400
  * assert response.title == 'MethodArgumentNotValidException'


Scenario: Update owner with null required fields returns 400 (API validates required fields)
  Given path 'owners'
  And request { firstName: 'Null', lastName: 'Fields', address: '123 Null St', city: 'Null City', telephone: '0000000' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: null, lastName: null, address: null, city: null, telephone: null }
  When method PUT
  Then status 400
  * assert response.title == 'MethodArgumentNotValidException'


Scenario: Update owner with empty required fields returns 400 (API validates required fields)
  Given path 'owners'
  And request { firstName: 'Empty', lastName: 'Fields', address: '123 Empty St', city: 'Empty City', telephone: '9999999' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: '', lastName: '', address: '', city: '', telephone: '' }
  When method PUT
  Then status 400
  * assert response.title == 'MethodArgumentNotValidException'


Scenario: Update owner with very long fields returns 400 (API validates field lengths)
  Given path 'owners'
  And request { firstName: 'Long', lastName: 'Fields', address: '123 Long St', city: 'Long City', telephone: '8888888' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: 'This is a very long first name that exceeds the maximum allowed length for the firstName field in the database schema and should trigger a validation error', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  When method PUT
  Then status 400
  * assert response.title == 'MethodArgumentNotValidException'


Scenario: Update owner with special characters returns 400 (API enforces validation)
  Given path 'owners'
  And request { firstName: 'Special', lastName: 'Chars', address: '123 Test St', city: 'Test City', telephone: '1234567' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: 'Updated-John', lastName: 'Updated-Doe', address: '456 Updated St #4B', city: 'Updated City, NY', telephone: '555-9999' }
  When method PUT
  Then status 400


Scenario: Update owner with numeric fields returns 400 (API enforces name patterns)
  Given path 'owners'
  And request { firstName: 'Numeric', lastName: 'Fields', address: '123 Num St', city: 'Num City', telephone: '2223334444' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: '123', lastName: '456', address: '789', city: '012', telephone: '555-9999' }
  When method PUT
  Then status 400

Scenario: Update owner with invalid authentication returns 204 (API doesn't require auth)
  Given path 'owners'
  And request { firstName: 'Auth', lastName: 'Invalid', address: '123 Auth St', city: 'Auth City', telephone: '5550000' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  * header Authorization = 'Basic invalid_credentials'
  When method PUT
  Then status 204


Scenario: Update owner without authentication returns 204 (API doesn't require auth)
  Given path 'owners'
  And request { firstName: 'Auth', lastName: 'None', address: '123 Auth St', city: 'Auth City', telephone: '5550000' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  * header Authorization = null
  When method PUT
  Then status 204


Scenario: Update owner with malformed JSON returns 500 (API throws HttpMessageNotReadableException)
  # Create owner first
  Given path 'owners'
  And request { firstName: 'Bad', lastName: 'Json', address: '123 Bad St', city: 'Bad City', telephone: '3334445555' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request '{"id": ' + ownerId + ', "firstName": "John", "lastName": "Doe", "invalid": }'
  When method PUT
  Then status 500
  * assert response.title == 'HttpMessageNotReadableException'


Scenario: Update owner with wrong content type returns 204 (API accepts any content type)
  Given path 'owners'
  And request { firstName: 'Wrong', lastName: 'Content', address: '123 Wrong St', city: 'Wrong City', telephone: '7778889999' }
  When method POST
  Then status 201
  * def ownerId = response.id

  Given path 'owners', ownerId
  And request { id: ownerId, firstName: 'John', lastName: 'Doe', address: '123 Main St', city: 'Anytown', telephone: '5551234' }
  * header Content-Type = 'text/plain'
  When method PUT
  Then status 204
