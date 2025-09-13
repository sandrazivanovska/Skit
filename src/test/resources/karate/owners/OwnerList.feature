Feature: List Owners API (GET /owners)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: List owners successfully returns 200 with non-empty list
    Given path 'owners'
    When method GET
    Then status 200
    * assert response != null
    * assert response.length > 0

  Scenario: List owners with invalid authentication returns 200 (API doesn't require auth)
    Given path 'owners'
    * header Authorization = 'Basic invalid_credentials'
    When method GET
    Then status 200

  Scenario: List owners without authentication returns 200 (API doesn't require auth)
    Given path 'owners'
    * header Authorization = null
    When method GET
    Then status 200

  Scenario: List owners with malformed URL returns 500 (API throws NoResourceFoundException)
    Given path 'owners', 'invalid'
    When method GET
    Then status 500
    * assert response.title != null
    * assert response.detail != null

  Scenario: List owners with trailing slash returns 500 (API throws NoResourceFoundException)
    Given path 'owners', ''
    When method GET
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: List owners with extra path segments returns 500 (API throws NoResourceFoundException)
    Given path 'owners', 'extra', 'segments'
    When method GET
    Then status 500
    * assert response.title == 'NoResourceFoundException'
    * assert response.detail.indexOf('No static resource') >= 0

  Scenario: List owners with query parameters returns 200
    Given path 'owners'
    And param lastName = 'Doe'
    When method GET
    Then status 200
    * assert response != null

  Scenario: List owners with empty query parameters returns 200
    Given path 'owners'
    And param lastName = ''
    When method GET
    Then status 200
    * assert response != null

  Scenario: List owners with multiple query parameters returns 200
    Given path 'owners'
    And param lastName = 'Doe'
    And param limit = 10
    When method GET
    Then status 200
    * assert response != null
